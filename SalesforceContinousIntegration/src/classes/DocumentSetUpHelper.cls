/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   02/06/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class DocumentSetUpHelper {
    
    //to get the picklist value of specified object annd field
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        try{
        return Utility.getPicklistValues(ObjectApi_name,Field_name);   
        }Catch(Exception e){
            HandleBusinessException.captureError('DocumentSetUpHelper', 'DocumentSetUpHelper', e);
            return null;
        }
    }
    
    // to get existing mapping config for specified type and subtype
    public static Mapping_Configurations__c getMppingConfigForTypeAndSubType(String typeName,String subType){
        return [Select id,Type__c,SubType__c,Type_Subtype__c,Status__c,Active__c,Allow_Stage__c,Allow_LineItems__c,Allow_Files__c from Mapping_Configurations__c Where Type__c=:typeName AND SubType__c=:subType LIMIT 1];
    }
    
    // upsert of mapping configuration sent through DocumentSetupWrapper with allowed stages,store fiels and allow fiels values
    public static void createMappingConfigurations(String documentSetupWrpAsString){
        try{
        DocumentSetupWrapper documentSetupWrp = DocumentSetupWrapper.parse(documentSetupWrpAsString);
        
        List<Mapping_Configurations__c> mappingconfiguration = [Select id,Type__c,SubType__c,Type_Subtype__c,Active__c,Allow_Stage__c,Allow_LineItems__c,Allow_Files__c from Mapping_Configurations__c Where Type__c=:documentSetupWrp.types AND SubType__c=:documentSetupWrp.subType LIMIT 1];
        
        Mapping_Configurations__c mappngConfig = new Mapping_Configurations__c(Type__c=documentSetupWrp.types,SubType__c=documentSetupWrp.subType,Type_Subtype__c=documentSetupWrp.types+'-'+documentSetupWrp.subType,Allow_Stage__c=documentSetupWrp.allowedStage,Allow_Files__c=documentSetupWrp.storeFiles,Allow_LineItems__c=documentSetupWrp.allowLineItem,Stage__c=Constants.STAGE5_MAP_CONFIG);

          //upsert value mapping data
         List<Schema.SObjectField> mappngConfigFieldsList = FieldAccessibilityUtility.fetchMappingConfigurationFields();        
         SecurityUtils.checkInsert(Mapping_Configurations__c.SObjectType,mappngConfigFieldsList);
         SecurityUtils.checkUpdate(Mapping_Configurations__c.SObjectType,mappngConfigFieldsList);
        
        if(mappingconfiguration.size() == 0){
            insert mappngConfig;
        }else{
            mappngConfig.Id = mappingconfiguration[0].id;
            update mappngConfig;
        }
        }Catch(Exception e){
            HandleBusinessException.captureError('DocumentSetUpHelper', 'createMappingConfigurations', e);
        }
    }
    
    //to activate the mapping config
    public static void activateMappingConfigurations(String activateMappngConfigAsString){
        try{
        ActivateWrapper activateMpConfigWrp = ActivateWrapper.parse(activateMappngConfigAsString);
        
        List<Mapping_Configurations__c> mappingconfiguration = [Select id,Type__c,SubType__c,Type_Subtype__c,Active__c,Status__c,Allow_Stage__c,Allow_LineItems__c,Allow_Files__c from Mapping_Configurations__c Where Type__c=:activateMpConfigWrp.types AND SubType__c=:activateMpConfigWrp.subType LIMIT 1];
        
        
         //update value mapping data
         List<Schema.SObjectField> mappngConfigFieldsList = FieldAccessibilityUtility.fetchMappingConfigurationFields();        
         SecurityUtils.checkUpdate(Mapping_Configurations__c.SObjectType,mappngConfigFieldsList);
        
        if(mappingconfiguration.size() != 0){
            Mapping_Configurations__c mappngConfig = new Mapping_Configurations__c(Id=mappingconfiguration[0].id,Status__c=activateMpConfigWrp.activateMappingconfig,Stage__c=Constants.STAGE5_MAP_CONFIG);
            update mappngConfig;
        }
        }Catch(Exception e){
            HandleBusinessException.captureError('DocumentSetUpHelper', 'activateMappingConfigurations', e);
        }
    }
}