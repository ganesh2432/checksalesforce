/*
* @Author             : Rahul Sangwan
* Created By          : Rahul Sangwan (30/04/2018)
* Last Modified By    : Rahul Sangwan (31/05/2018)
* @Description        : Controller for ObjectBasedFieldMapping Component. 
*/
public with sharing class ObjectBasedFieldMappingHelper {
    public static Map<String,String> objectWithLabelandName  = new Map<String,String>();
    

    //Purpose : To get Labels of all Objects in Org.
    public static List<String>  getObjectsLabels() {
        
        List<Schema.SObjectType> ObjectDetails     = Schema.getGlobalDescribe().Values();     
        
        List<String> ObjectLabels = new List<String>();
        for(Schema.SObjectType objDtl : ObjectDetails){
            objectWithLabelandName.put(objDtl.getDescribe().getLabel(),objDtl.getDescribe().getName());
            ObjectLabels.add(objDtl.getDescribe().getLabel());
        }
        
        return ObjectLabels;   
    }
    
    
    //Purpose : To get all Fields of an Object(Other than system, Autonumber and formula fields).
    public static Map<String, FieldsForObjectRespWrapper> getFieldsDetailsForParticularObject(String ObjectLable){
        getObjectsLabels();
        Map<String,FieldsForObjectRespWrapper> options		= new Map<String,FieldsForObjectRespWrapper>();
        Map <String, Schema.SObjectType> schemaMap  		= Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap  		= schemaMap.get(objectWithLabelandName.get(ObjectLable)).getDescribe().fields.getMap();
        List<String> fieldsList                     		= new List<String>();
        List<String> systemFields 							= new List<String>();
        List<System_Fields__mdt> systemFieldsList			= new List<System_Fields__mdt>();
        systemFieldsList 									= ObjectBasedFieldMappingControllerModel.getSystemFieldsList();
        for(System_Fields__mdt sysFieldsObj : systemFieldsList){
            fieldsList.add(sysFieldsObj.DeveloperName);
        }
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult field = sfield.getDescribe();
            if(!fieldsList.contains(field.getname()) && !field.isAutoNumber() && !field.isCalculated()){
            	options.put(field.getname(), new FieldsForObjectRespWrapper(field.getname(), field.getLabel(), String.valueOf(field.getType())));    
            }
        }
        return options;
    }
    
    
    //Purpose : To get Map of IContract field datatype and corresponding supported Salesforce field datatype.  
    public static Map<String, String> getContractAndSFFieldDataTypeMapping(){
        Map<String, String> contractAndSFFieldTypeMap 					= new Map<String, String>();
        List<Icontract_and_Salesforce_Field_Mapping__mdt> listFieldMDT 	= new List<Icontract_and_Salesforce_Field_Mapping__mdt>();
        listFieldMDT 	= ObjectBasedFieldMappingControllerModel.getContractAndSfDataTypeMapping();
        for(Icontract_and_Salesforce_Field_Mapping__mdt fTypeObj : listFieldMDT){
            contractAndSFFieldTypeMap.put(fTypeObj.DeveloperName , fTypeObj.Salesforce_Field_Datatype__c);
        }
    	return contractAndSFFieldTypeMap;    
    }
    
    
    //Purpose : To get Objects from Custom metadata, which needs to be shown for field mapping
    //          in Object 1 and Object 2.
    public static Map<String, List<String>> getObjectsToMapFromCM(){
        Map<String, List<String>> mappingObjectsMap	= new Map<String, List<String>>();
        List<Object_Mapping_Record__mdt> mappingObjectsList 			= new List<Object_Mapping_Record__mdt>();
        mappingObjectsList 												= ObjectBasedFieldMappingControllerModel.getObjectToMapRecList();
        for(Object_Mapping_Record__mdt mappingObjRec : mappingObjectsList){
            if(mappingObjectsMap.containsKey(mappingObjRec.Object_Type__c))
                mappingObjectsMap.get(mappingObjRec.Object_Type__c).add(mappingObjRec.DeveloperName);
            else
                mappingObjectsMap.put(mappingObjRec.Object_Type__c, new List<String>{mappingObjRec.DeveloperName});                
        }
        return mappingObjectsMap;
    }
    
    
    //Purpose : To Save the Field selected for Object 1 and Object 2, agains IContract fields.
    public static String saveIcontractRecords(ObjectMappingRespWrapper recordList, String mapConfigId, String object1, String object2){
        Map<String, IContract_MetaData__c> fNameAndMetadataRec 	= new Map<String, IContract_MetaData__c>();
        List<IContract_MetaData__c> metadataRecList 			= new List<IContract_MetaData__c>();
        metadataRecList											= ObjectBasedFieldMappingControllerModel.getMetadataOfConfigList(mapConfigId);
        for(IContract_MetaData__c metadataObj : metadataRecList){
            fNameAndMetadataRec.put(metadataObj.Field_Name__c , metadataObj);
        }
        try{
            updateMetadataRec(recordList, fNameAndMetadataRec, object1, object2, mapConfigId);
            return 'SUCCESS';
        }catch(Exception e){
            HandleBusinessException.captureError('ObjectBasedFieldMappingHelper', 'saveIcontractRecords', e);
            system.debug('Exception::::'+e.getMessage());
            return e.getMessage();
        }
    }
    
    
    //Purpose : To get Create new field URL for the object, based on type of Object : Standard or Custom
    //          and then based on the View: Lightning or Classic.
    public static String getObjectFieldSetUpURL(String objectName, String urlTheme){
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
    
    
    //Purpose : To get the ICntract Metadata records for paticular mapping config.
    public static Map<String, IContract_MetaData__c> getMetadataRecords(String mapConfigId){
        Map<String, IContract_MetaData__c> fieldAndMetadataMap 	= new Map<String, IContract_MetaData__c>();
        List<IContract_MetaData__c> metadataList 				= new  List<IContract_MetaData__c>();
        metadataList 											= ObjectBasedFieldMappingControllerModel.getMetadataOfConfigList(mapConfigId);
        for(IContract_MetaData__c metadataObj : metadataList){
            fieldAndMetadataMap.put(metadataObj.Field_Name__c, metadataObj);
        }
        return fieldAndMetadataMap;
    }
    
    
    static void updateMetadataRec(ObjectMappingRespWrapper recordList, Map<String, IContract_MetaData__c> fNameAndMetadataRec, String object1, String object2, String mapConfigId){
        List<IContract_MetaData__c> metadataList 	= new List<IContract_MetaData__c>();
        for(ObjectMappingRespWrapper.cls_objectMap wrapObj : recordList.objectMap){
            IContract_MetaData__c metadataObj = new IContract_MetaData__c();
            if(fNameAndMetadataRec.containsKey(wrapObj.fieldName)){
				metadataObj.Id 					= fNameAndMetadataRec.get(wrapObj.fieldName).Id;
                metadataObj.Mapping_Field__c	= wrapObj.mappingField1;
                metadataObj.Mapping_Object__c	= object1;
                metadataObj.Mapping_Field_2__c	= wrapObj.mappingField2;
                metadataObj.Mapping_Object_2__c	= object2;
                metadataObj.Sot__c              = wrapObj.sot;
                metadataList.add(metadataObj);
            }
        }
        if(!metadataList.isEmpty()){
            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.icontractMetadatafields();        
            SecurityUtils.checkUpdate(IContract_MetaData__c.SObjectType,requestFieldsList);
            
            update metadataList;
            Mapping_Configurations__c mappingConfigObj  = new Mapping_Configurations__c(Id = mapConfigId, Stage__c = Constants.STAGE2_MAP_CONFIG);
            update mappingConfigObj;
        }
    }
    
}