/*----------------------------------------------------------------------------
* Description :   This controller is used for value mapping
* Created By  :   Jayanth B
* Created Date:   02/06/2018  
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class LineItemValueMapping {

    @AuraEnabled //used to get fields for value mapping 
    public static List<IContract_MetaData__c> getIContractFields(){       
        return  LineItemValueMappingHelper.getIContractFields();
    }
    
    // Used to get field values to map with the vlaue sof icontract
    @AuraEnabled
    public static LineItemValueMappingHelper.existingCheckWrapper getSelectedFieldsValuesFromIcontractAndSalesforce(String ObjectName,String FieldName,List<String> allowedValues,String fieldNameForExistingCheck){
        return LineItemValueMappingHelper.getSelectedFieldsValuesFromIcontractAndSalesforce(ObjectName,FieldName,allowedValues,fieldNameForExistingCheck);
    }
    
    @AuraEnabled // making efficient check later on
    public static void saveValueMapping(List<Value_Mapping__c> valueMappingRecords){
        LineItemValueMappingHelper.saveValueMapping(valueMappingRecords);
    }

    @AuraEnabled //To check is value mapping is completed or not
    public static List<String> isAllValueMappingComplete(List<IContract_MetaData__c> iConMetadata,boolean isForLineItem){
       Set<String> unmaapedFieldNames = LineItemValueMappingHelper.isAllValueMappingComplete(iConMetadata,isForLineItem);
       List<String> unmmapedFieldNameList = new List<String>();
       unmmapedFieldNameList.addAll(unmaapedFieldNames); // converted from set to list coz Set type cant be returned from auraEnabled method
       return unmmapedFieldNameList;
    }
}