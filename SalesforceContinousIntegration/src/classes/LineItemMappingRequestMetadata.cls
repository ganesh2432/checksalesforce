/*----------------------------------------------------------------------------
* Description :   This controller is to store icontract metadata 
                  + field selection + field mapping for line item metadata.
* Created By  :   Jayanth B
* Created Date:   24/05/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class LineItemMappingRequestMetadata {

    // To get Metadata details for Line item mapping from iContract
    @AuraEnabled
    public static FetchMetadataAPICtrl.Response service() {
        return FetchMetadataAPICtrl.getFieldMetadataCallout();
    }
    
    //To get fields name for specified object
    @AuraEnabled
    public static Map<String,FieldsForObjectRespWrapper> getFieldsDetailsForParticularObject(String ObjectLable){
        return ObjectBasedFieldMappingHelper.getFieldsDetailsForParticularObject(ObjectLable);
    }
    
    // to get field name with datatype
    @AuraEnabled
    public static Map<String, String> getContractAndSFFieldDataTypeMapping(){
        return ObjectBasedFieldMappingHelper.getContractAndSFFieldDataTypeMapping();
    }
    
    // to get object name for Line item mapping configuration
    @AuraEnabled
    public static Object_Mapping_Record__mdt getObjectNameForLineItemMapping(){
        try{
        return [Select Id, Object_Type__c, MasterLabel, DeveloperName 
                from Object_Mapping_Record__mdt where Object_Type__c=:system.label.Line_Item LIMIT 1];
        }Catch(Exception e){
            HandleBusinessException.captureError('LineItemMappingRequestMetadata', 'getObjectNameForLineItemMapping', e);
            return null;
        }
    }
    
    //To get URL for redirecting to field creation based on lightning or classic
    /*@AuraEnabled
    public static String getObjectFieldSetUpURL(String objectName, String urlTheme){
        return ObjectBasedFieldMappingHelper.getObjectFieldSetUpURL(objectName, urlTheme);
    }*/
    @AuraEnabled
    public static String getObjectFieldSetUpURL(String objectName, String urlTheme){
        return getObjectFieldSetUpURLcont(objectName, urlTheme);
    }
    
    // used to save mapped icontract field data with salesforce line item data
    @AuraEnabled
    public static String mappingObjectFieldForLineItemSelectedFields(String mappedFieldsData){
        return LineItemMappingRequestMetadataHelper.mappingObjectFieldForLineItemSelectedFields(mappedFieldsData);
    }
    
    // To create/update lineItem data for icontract field metadata object
    @AuraEnabled
    public static String createLineItemFieldsMetadata(String fieldSelectedData){
        return LineItemMappingRequestMetadataHelper.createLineItemFieldsMetadata(fieldSelectedData);
    }
    
    //used for displaying Map lineItem / ReviewLine item mapping buttons
    @AuraEnabled
    public static boolean isDataExist(){
        try{
            List<IContract_MetaData__c> iconMetadataForLineItemExist =  [Select Id, Field_Name__c from IContract_MetaData__c where LineItem_Data__c=:true AND IsLineItemActive__c=:true LIMIT 2];
            if(iconMetadataForLineItemExist.size()>0){return true;}else{ return false;}
        }Catch(Exception e){
            return false;
        }
    }
    
    // gets existing data from salesforce for line item field selections
    @AuraEnabled
    public static List<IContract_MetaData__c> getExistingLineItemData(boolean isItFromComponent){ 
        return LineItemMappingRequestMetadataHelper.getExistingLineItemData(isItFromComponent);
    }
    
    
    
    //remove after rahul completes
    //Purpose : To get Create new field URL for the object, based on type of Object : Standard or Custom
    //          and then based on the View: Lightning or Classic.
    public static String getObjectFieldSetUpURLcont(String objectName, String urlTheme){
        Boolean isCustom	= 	schema.getglobaldescribe().get(objectName).getdescribe().isCustom();
        if(urlTheme == 'Theme4d')
        return getObjectFieldSetUpURLForLightning(objectName, isCustom);        
        else 
        return getObjectFieldSetUpURLForClassic(objectName, isCustom);
    }


    static String getObjectFieldSetUpURLForLightning(String objectName, Boolean isCustom){
        if(isCustom) {
            objectName = objectName.removeEnd('__c');
            
            String query = 'SELECT Id From CustomObject Where DeveloperName = \'' + objectName + '\'';
            String endpoint = Url.getSalesforceBaseUrl().toExternalForm();
            endpoint += '/services/data/v29.0/tooling/query/?q=';
            endpoint += EncodingUtil.urlEncode(query, 'UTF-8');
            
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            request.setEndpoint(endpoint);
            Id customObjectId ;
            if(!Test.isRunningTest()) {
            	HttpResponse response = new Http().send(request); 
                customObjectId 		  = response.getBody().substringAfter('"Id":"').substringBefore('"');
            }
            
            return '/setup/ObjectManager/'+customObjectId+'/FieldsAndRelationships/view';   
        }
        else return '/setup/ObjectManager/'+objectName+'/FieldsAndRelationships/view';
    }


    static String getObjectFieldSetUpURLForClassic(String objectName, Boolean isCustom){
        if(isCustom) {
            objectName = objectName.removeEnd('__c');
            
            String query = 'SELECT Id From CustomObject Where DeveloperName = \'' + objectName + '\'';
            String endpoint = Url.getSalesforceBaseUrl().toExternalForm();
            endpoint += '/services/data/v29.0/tooling/query/?q=';
            endpoint += EncodingUtil.urlEncode(query, 'UTF-8');
            
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            request.setEndpoint(endpoint);
            Id customObjectId ;
            if(!Test.isRunningTest()){
            	HttpResponse response = new Http().send(request);
            	customObjectId = response.getBody().substringAfter('"Id":"').substringBefore('"');
            }
            return '/'+customObjectId;   
        }
        else return '/p/setup/layout/LayoutFieldList?type='+objectName;
    }
    
    

    
    //LineItemFieldMetadata response wrapper
    public class Response {
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public Integer statusCode { get; set; }
        @AuraEnabled
        public String body { get; set; }
    }
    

}