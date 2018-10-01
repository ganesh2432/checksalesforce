/*----------------------------------------------------------------------------
* Description :   This helper is used for Contract request wizard
* Created By  :   Jayanth B
* Created Date:   02/06/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class RequestWizardHelper {

    //saving contract request wizard questions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      `                                                                                                                                                                                                                                                                                                                                                                                                                                               
    public static void SaveRequestWizard(List<Request_Wizard_MetaData__c> reqWizardList){
        //for loop added because it was taking it as Sobject and upsert for sobject was not working. type casting needs to be done and removal of for loop later on
        List<Request_Wizard_MetaData__c> upsertreqWizardList = new List<Request_Wizard_MetaData__c>();
        //for maintaining Stage value
        String typeName = '';
        String subTypeName = '';
        //
        for(Request_Wizard_MetaData__c rw: reqWizardList){
            upsertreqWizardList.add(rw);
            //for maintaining Stage value
            if(typeName == ''){
                typeName = rw.Type__c;
                subTypeName = rw.SubType__c;
            }
            //
        }
        try{
        //for maintaining Stage value
        Mapping_Configurations__c mppConfig = [Select id from Mapping_Configurations__c where Type__c=:typeName and SubType__c=:subTypeName LIMIT 1];
        //
            
         //upsert value mapping data
         List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.requestWizardFields();        
         SecurityUtils.checkInsert(Request_Wizard_MetaData__c.SObjectType,requestFieldsList);
         SecurityUtils.checkUpdate(Request_Wizard_MetaData__c.SObjectType,requestFieldsList);
         
         //for maintaining Stage value   
         List<Schema.SObjectField> mappngConfigFieldList = FieldAccessibilityUtility.fetchMappingConfigurationFields();
         SecurityUtils.checkUpdate(Request_Wizard_MetaData__c.SObjectType,mappngConfigFieldList);
         //   
            if(upsertreqWizardList.size()>0)
               upsert upsertreqWizardList;
        
         //for maintaining Stage value   
            if(mppConfig!=null)
                update new Mapping_Configurations__c(Id=mppConfig.id,Stage__c = Constants.STAGE4_MAP_CONFIG);
         //   
        }Catch(Exception e){
            HandleBusinessException.captureError('RequestWizardHelper', 'SaveRequestWizard', e);
        }
    }
    
    //used to get the existing request wizard question
    public static List<Request_Wizard_MetaData__c > getRequestWizardsMetadata(String selectedType,String selectedSubType,boolean isReqPresent){
        try{
            
            List<Request_Wizard_MetaData__c> requestedWizardMetaData = [Select Id,Order_No__c,Mandatory_in_Icontract__c,Field_Name__c,Mandatory__c,Question__c,Type__c,SubType__c,IContract_Field_Metadata__c,IsRequired__c 
                                                                        From Request_Wizard_MetaData__c Where IContract_Field_Metadata__r.Mapping_Configurations__r.Type__c=:selectedType and IContract_Field_Metadata__r.Mapping_Configurations__r.SubType__c=:selectedSubType and IContract_Field_Metadata__r.Active__c=:true Order by Order_No__c ASC NULLS LAST]; 
            
            Mapping_Configurations__c mpgConfig = [Select Id,Type__c,SubType__c,(Select Id,Mandatory__c,Display_Name__c,Mapping_Configurations__r.Type__c,Mapping_Configurations__r.SubType__c  
                                                                         From IContract_Fields_Metadata__r where Active__c=:true) from Mapping_Configurations__c Where Type__c=:selectedType and SubType__c=:selectedSubType LIMIT 1];
            
            List<Request_Wizard_MetaData__c> dummyReqWzrd = new List<Request_Wizard_MetaData__c>();
            system.debug(mpgConfig.IContract_Fields_Metadata__r.size());
            if(mpgConfig.IContract_Fields_Metadata__r.size() != requestedWizardMetaData.size()){
                Set<String> existingCheck = new Set<String>();
                Integer counter = 0;
                for(Request_Wizard_MetaData__c reqMtd : requestedWizardMetaData){
                    existingCheck.add(reqMtd.Field_Name__c);
                    if(reqMtd.Order_No__c == Null){
                        counter = counter +1;
                    }
                }
                Integer j = 1;
                for(Integer i=0;i<mpgConfig.IContract_Fields_Metadata__r.size();i++){
                    if(!existingCheck.contains(mpgConfig.IContract_Fields_Metadata__r[i].Display_Name__c)){
                        dummyReqWzrd.add(new Request_Wizard_MetaData__c(Mandatory_in_Icontract__c=mpgConfig.IContract_Fields_Metadata__r[i].Mandatory__c,Order_No__c=j+requestedWizardMetaData.size()-counter,IContract_Field_Metadata__c=mpgConfig.IContract_Fields_Metadata__r[i].Id,Field_Name__c=mpgConfig.IContract_Fields_Metadata__r[i].Display_Name__c,Mandatory__c=false,Question__c=system.label.Question_prefix_Text+' '+mpgConfig.IContract_Fields_Metadata__r[i].Display_Name__c,Type__c=mpgConfig.IContract_Fields_Metadata__r[i].Mapping_Configurations__r.Type__c,SubType__c=mpgConfig.IContract_Fields_Metadata__r[i].Mapping_Configurations__r.SubType__c,IsRequired__c=false));
                        j = j+1;
                    }
                }
                requestedWizardMetaData.addall(dummyReqWzrd);
                
            }
            
            if(requestedWizardMetaData.size()>0 && isReqPresent){
                return  requestedWizardMetaData;
            }else{
                
                List<IContract_MetaData__c> icontractMetaData = new List<IContract_MetaData__c>();
                icontractMetaData.addAll(mpgConfig.IContract_Fields_Metadata__r);
                
                List<Request_Wizard_MetaData__c>  unsavedRequestWizard = new List<Request_Wizard_MetaData__c>();
                system.debug(icontractMetaData);
                for(Integer i=0;i<icontractMetaData.size();i++){
                    unsavedRequestWizard.add(new Request_Wizard_MetaData__c(Mandatory_in_Icontract__c=icontractMetaData[i].Mandatory__c,Order_No__c=i+1,Field_Name__c=icontractMetaData[i].Display_Name__c,Mandatory__c=false,Question__c=system.label.Question_prefix_Text+' '+icontractMetaData[i].Display_Name__c,IContract_Field_Metadata__c=icontractMetaData[i].Id,Type__c=icontractMetaData[i].Mapping_Configurations__r.Type__c,SubType__c=icontractMetaData[i].Mapping_Configurations__r.SubType__c,IsRequired__c=false));                
                }
                return unsavedRequestWizard;
            }
        }Catch(Exception e){
            HandleBusinessException.captureError('RequestWizardHelper', 'getRequestWizardsMetadata', e);
            return null;
        }
    }

}