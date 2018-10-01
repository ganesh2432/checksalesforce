/*----------------------------------------------------------------------------
* Description :   This helper is used for value mapping
* Created By  :   Jayanth B
* Created Date:   02/06/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class LineItemValueMappingHelper {
    
    //to get field list for value  mapping 
    public static List<IContract_MetaData__c> getIContractFields(){       
        List<IContract_MetaData__c> IContractFieldList = new List<IContract_MetaData__c>();
        try{
            //query field mapping from custom metadata
            List<String> enumList = ValueMappingControllerModel.getFieldMapping();
            //query Icontract fields
            IContractFieldList = getLineItemFieldsForValueMapping(enumList);
        }
        catch(Exception e){
            HandleBusinessException.captureError('LineItemValueMappingHelper', 'typeAndSubtypeCallout', e);
            throw new CustomException(e.getMessage());
        }
        return IContractFieldList; 
    }
    
    // Used to get field values to map with the vlaue sof icontract
    public static existingCheckWrapper getSelectedFieldsValuesFromIcontractAndSalesforce(String ObjectName,String FieldName,List<String> allowedValues,String fieldNameForExistingCheck){
        try{
        if(ObjectName == System.label.Opportunity_Product){
            ObjectName = System.label.OpportunityLineItem;
        }        
        existingCheckWrapper existinwrp = new existingCheckWrapper();
        List<String> selectedFieldObjPickListValues = new List<String>();
        selectedFieldObjPickListValues.add('Select Value');
        selectedFieldObjPickListValues.addall(LineITemValueMappingController.getEnumListValues(ObjectName,FieldName));
        existinwrp.PickListValues = selectedFieldObjPickListValues;
        existinwrp.existingValueMapping = [Select Id,IContract_Value__c,Mapping_Field__c,Mapping_Value__c,Mapping_Object__c,Field_Name__c From Value_Mapping__c where Field_Name__c=:fieldNameForExistingCheck];
        return existinwrp;
        }catch(Exception e){
            HandleBusinessException.captureError('LineItemValueMappingHelper', 'getSelectedFieldsValuesFromIcontractAndSalesforce', e);
            return null;
        }
    }
    
    //getting linbe item enul fields for value mapping
    public static List<IContract_MetaData__c> getLineItemFieldsForValueMapping(List<String> enumList){
        try{
        List<IContract_MetaData__c> IContractFieldList = new List<IContract_MetaData__c>();
        IContractFieldList = [select id,Mapping_Field__c,Display_Name__c,Mapping_Object__c,LineItem_Data__c,IsLineItemActive__c,
                              Field_Name__c,DataType__c,AllowedValues__c,Active__c from IContract_MetaData__c where IsLineItemActive__c=:true and LineItem_Data__c=:true and DataType__c IN:enumList and Mapping_Field__c != 'Select Field' and Mapping_Field_2__c != 'Select Field'];
        
        return IContractFieldList;
        }catch(Exception e){
            HandleBusinessException.captureError('LineItemValueMappingHelper', 'getLineItemFieldsForValueMapping', e);
            return null;
        }
    }
    
    //Saving the mapped values
    public static void saveValueMapping(List<Value_Mapping__c> valueMappingRecords){
        try{
            Set<String> fieldNames = new Set<String>();
        for(Value_Mapping__c valMap : valueMappingRecords){
            fieldNames.add(valMap.Field_Name__c);
        }
        List<IContract_MetaData__c> icontractRecords = [Select id,Field_Name__c,Display_Name__c,(Select id,IContract_Field_Metadata__c,IContract_Value__c from Value_Mappings__r) from IContract_MetaData__c where Display_Name__c=:fieldNames and LineItem_Data__c=:true];
        Map<String,String> icontractFieldID = new Map<String,String>();    
        Map<String,String> valueMappingIDBasedOnIconValue = new Map<String,String>();    
        for(IContract_MetaData__c icntrctMtd : icontractRecords){
            icontractFieldID.put(icntrctMtd.Display_Name__c,icntrctMtd.id);
            if(icntrctMtd.Value_Mappings__r.size()>0){
                for(Value_Mapping__c vmp : icntrctMtd.Value_Mappings__r){
                    valueMappingIDBasedOnIconValue.put(vmp.IContract_Value__c,vmp.id);
                }
            }
        }
            
            
        List<Value_Mapping__c> updateValueMappngList = new List<Value_Mapping__c>();
        for(Value_Mapping__c valMap : valueMappingRecords){
            if(valueMappingIDBasedOnIconValue.containsKey(valMap.IContract_Value__c))
                valMap.Id 						    = valueMappingIDBasedOnIconValue.get(valMap.IContract_Value__c);
            
            valMap.ValueMappingExternalID__c = valMap.Field_Name__c+'-'+valMap.IContract_Value__c.replace(' ', '');
            valMap.IContract_Field_Metadata__c = icontractFieldID.get(valMap.Field_Name__c);
            updateValueMappngList.add(valMap);
        }
            
        //upsert value mapping data
            List<Schema.SObjectField> valueMappingFieldsList = FieldAccessibilityUtility.fetchValueMappingFields();
            SecurityUtils.checkUpdate(Value_Mapping__c.SObjectType,valueMappingFieldsList);    
            system.debug(updateValueMappngList);
        if(!updateValueMappngList.isEmpty())
            upsert updateValueMappngList ValueMappingExternalID__c;
            //Database.upsert(updateValueMappngList,Value_Mapping__c.Fields.ValueMappingExternalID__c, false);
        }catch(Exception e){
            HandleBusinessException.captureError('LineItemValueMappingHelper', 'saveValueMapping', e);
        }
    }
    
    //To check is value mapping is completed or not
    public static Set<String> isAllValueMappingComplete(List<IContract_MetaData__c> iConMetadata,Boolean isForLineItem){
        try{
        Set<String> iContMetadataIDs = new Set<String>();
        for(IContract_MetaData__c icon : iConMetadata){
            iContMetadataIDs.add(icon.id);
        }
        
        List<IContract_MetaData__c> iConMetadataToCheckValMappng = [Select id,AllowedValues__c,Display_Name__c,Field_Name__c,Mapping_Field__c,Mapping_Object__c,(Select id,Field_Name__c,IContract_Field_Metadata__c,IContract_Value__c,Mapping_Field__c,Mapping_Object__c,Mapping_Value__c,Mapping_Value2__c,Mapping_Object2__c,Mapping_Field2__c from Value_Mappings__r) from IContract_MetaData__c where id=:iContMetadataIDs];
        Set<String> unMappedValues = new Set<String>();
        for(IContract_MetaData__c icon : iConMetadataToCheckValMappng){
            List<string> allowedValues= icon.AllowedValues__c.split(',');
            
            if(allowedValues.size() == icon.Value_Mappings__r.size()){
                for(Value_Mapping__c valmppng : icon.Value_Mappings__r){
                    
                    if(valmppng.IContract_Value__c == null || valmppng.IContract_Value__c == '' 
                       || valmppng.Mapping_Object__c == null || valmppng.Mapping_Object__c == ''
                       || valmppng.Mapping_Field__c == null || valmppng.Mapping_Field__c == ''
                       || valmppng.Mapping_Value__c == null || valmppng.Mapping_Value__c == ''){
                           unMappedValues.add(icon.Display_Name__c);
                       }else if(!isForLineItem){
                           if(valmppng.Mapping_Object2__c == null || valmppng.Mapping_Object2__c == ''
                              || valmppng.Mapping_Field2__c == null || valmppng.Mapping_Field2__c == ''
                              || valmppng.Mapping_Value2__c == null || valmppng.Mapping_Value2__c == ''){
                                  unMappedValues.add(icon.Display_Name__c);
                              }
                       }
                }
            }else{
                unMappedValues.add(icon.Display_Name__c);
            }
        }
        
        return unMappedValues;
      }catch(Exception e){
            HandleBusinessException.captureError('LineItemValueMappingHelper', 'isAllValueMappingComplete', e);
          return null;
        }  
        
    }
    
    public class existingCheckWrapper{
        @AuraEnabled
        public List<String> PickListValues;
        @AuraEnabled
        public List<Value_Mapping__c> existingValueMapping;
        
        public existingCheckWrapper(){
            PickListValues = new List<String>();
            existingValueMapping = new List<Value_Mapping__c>();
        }
    }
}