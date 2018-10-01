/*
* @Author             : Rahul Sangwan
* Created By          : Rahul Sangwan (30/04/2018)
* Last Modified By    : Rahul Sangwan (31/05/2018)
* @Description        : Controller for ObjectBasedFieldMapping Component. 
*/
public with sharing class ObjectBasedFieldMappingController {

  /*  @AuraEnabled
    public FieldDetailWrapper  fieldWrapper;
*/

    //Purpose : To get Labels of all Objects in Org.
    @AuraEnabled
    public static List<String>  getObjectsLabels() {
        return ObjectBasedFieldMappingHelper.getObjectsLabels();
    }
    
    
    //Purpose : To get all Fields of an Object(Other than system fields and formula fields).
    @AuraEnabled
    public static Map<String,FieldsForObjectRespWrapper> getFieldsDetailsForParticularObject(String ObjectLable){
       return ObjectBasedFieldMappingHelper.getFieldsDetailsForParticularObject(ObjectLable);
    }
    
    
    //Purpose : To get Objects from Custom metadata, which needs to be shown for field mapping
    //          in Object 1 and Object 2.
    @AuraEnabled
    public static Map<String, List<String>> getObjectsToMapFromCM(){
        return ObjectBasedFieldMappingHelper.getObjectsToMapFromCM();
    }
    
    
    //Purpose : To get Create new field URL for the object, based on type of Object : Standard or Custom
    //          and then based on the View: Lightning or Classic.
    @AuraEnabled
    public static String getObjectFieldSetUpURL(String objectName, String urlTheme){
        return ObjectBasedFieldMappingHelper.getObjectFieldSetUpURL(objectName, urlTheme);
    }
    
    
    //Purpose : To get Map of IContract field datatype and corresponding supported Salesforce field datatype.  
    @AuraEnabled
    public static Map<String, String> getContractAndSFFieldDataTypeMapping(){
        return ObjectBasedFieldMappingHelper.getContractAndSFFieldDataTypeMapping();
    }
    
    
    //Purpose : To Save the Field selected for Object 1 and Object 2, agains ICOntract fields.
    @AuraEnabled
    public static String saveIcontractRecords(String recordList, String mapConfigId, String object1, String object2){
        recordList = '{"objectMap":' + recordList + '}';
        ObjectMappingRespWrapper respWrapObj = ObjectMappingRespWrapper.parse(recordList);
        return ObjectBasedFieldMappingHelper.saveIcontractRecords(respWrapObj, mapConfigId, object1, object2);        
    }
    
    
    //Purpose : To get the ICntract Metadata records for paticular mapping config.
    @AuraEnabled
    public static Map<String, IContract_MetaData__c> getMetadataRecords(String mapConfigId){
        return ObjectBasedFieldMappingHelper.getMetadataRecords(mapConfigId);
    }
    
    
}