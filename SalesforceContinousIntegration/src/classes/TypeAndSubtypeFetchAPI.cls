/*----------------------------------------------------------------------------
* Description :   This controller to call type and subtype API to fetch data.
* Created By  :   Siva Krishna Reddy B
* Created Date:   03/05/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class TypeAndSubtypeFetchAPI {
    
    //Variable Declaration
    public static string finalResponse;
    public static List<TypeAndSubtypeJSONClass.cls_type> typeAndSubtypeList; 
    public static TypeAndSubtypeJSONClass JSONstrcture;
    public static List<TypeAndSubtypeJSONClass.cls_integrationEntity> integrationEntityList;
    public static Map<String, List<String>> typeandSubTypeMap;
    public static List<TypeAndSubtypeJSONClass.cls_subType> subTypeList;
    public static List<Mapping_Configurations__c> mappingConfigList;
    public static Map<String, String> typeandTypeName;
    //Get Method
    //Method to call type and SubType API to fetch type and subtype details.
    //    @AuraEnabled
    public static void typeAndSubtypeCallout(){
        
        try{
            
            //get access data custom settings
            Basic_Authentication__c ba = Basic_Authentication__c.getOrgDefaults();
            
            //get signature
            DateTime dateTimeNow = dateTime.now();
            String nonce = ''+dateTimeNow.getTime()/1000;
            String endPointUrl = 'https://rmzygrate.zycus.com/Zygrate/rest/v2/icontract/endpoint/api/contractTypes';
            String signature = BasicAuthenticationClass.basicAuthentictionCallout('get',endPointUrl,nonce);
            
            //Authorization header
            Blob headerValue = Blob.valueOf(ba.Username__c+':'+ba.Password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            
            //Http callout 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/contractTypes');
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '12345');
            /*request.setHeader('x-zycus-nonce', nonce);
            request.setHeader('x-zycus-signature', signature);
            request.setHeader('x-zycus-applicationid', ba.Application_Id__c);
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('x-zycus-username',ba.Username__c);
            request.setHeader('Accept', 'application/json'); */
            HttpResponse response = http.send(request);
            
            //Process response
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            system.debug('finalResponse::::'+finalResponse);
            //process JSON and get results
            JSONstrcture = TypeAndSubtypeJSONClass.parse(finalResponse);  
            integrationEntityList = JSONstrcture.IntegrationEntities.integrationEntity;
            
            //Loop through Integration Entity List
            for(TypeAndSubtypeJSONClass.cls_integrationEntity integrationEntity:integrationEntityList){
                typeAndSubtypeList = integrationEntity.integrationEntityDetails.contractTypes.types.type;
            }
            //Initialize the map
            typeandSubTypeMap = new Map<String,List<String>>();
            typeandTypeName = new Map<String,String>();
            for(TypeAndSubtypeJSONClass.cls_type type:typeAndSubtypeList){
                string typeName = type.displayName;
                subTypeList = type.subTypes.subType;               
                List<String> subList = new List<String>();
                for(TypeAndSubtypeJSONClass.cls_subType subtype:subTypeList){
                    subList.add(subtype.displayName);
                }
                typeandSubTypeMap.put(typeName, subList);
				typeandTypeName.put(typeName,type.typeName);                
            }
            
            //Insert type and subtype in Mapping configuration object.
            //String typeSubtypeRecordtypeName = Contants.TYPE_SUBTYPE_RT;
            //String ObjectName = Contants.MAPPING_CONFIG_OBJ;
            //String typeSubtypeRecordtypeId = Utility.getRecordTypeId(ObjectName,typeSubtypeRecordtypeName);
            mappingConfigList = new List<Mapping_Configurations__c>();
            List<String> typeSubTypeValues 	= new List<String>();
            
            //Loop the map and process type and subtype
            for(String type:typeandSubTypeMap.keySet()){        	           
                if(typeandSubTypeMap.get(type)!=null){                
                    for(String subtype:typeandSubTypeMap.get(type)){                  
                        Mapping_Configurations__c mappingConfig = new Mapping_Configurations__c();
                        mappingConfig.Type__c 			= type;
                     //   mappingConfig.Status__c         = 'Draft in progress';
                        mappingConfig.SubType__c 		= subtype;
                        //mappingConfig.RecordTypeId 		= typeSubtypeRecordtypeId;
                        mappingConfig.Type_Subtype__c 	= type+'-'+subtype; 
                        mappingConfig.TypeName__c = typeandTypeName.get(type);
                        mappingConfig.Active__c 		= true;
                        typeSubTypeValues.add(type+'-'+subtype);
                        mappingConfigList.add(mappingConfig);
                    }  
                }
            }
            
            List<Mapping_Configurations__c> existingMappingConfig 	= new List<Mapping_Configurations__c>();
            try{
            	existingMappingConfig 								= TypeAndSubtypeFetchAPIModel.getAllExistingMappingConfigs();    
            }catch(Exception e){}
            
            if(!existingMappingConfig.isEmpty()){
                List<Mapping_Configurations__c> mappingConfigToDecativateList 	= new List<Mapping_Configurations__c>();
                for(Mapping_Configurations__c mappingConfigObj : existingMappingConfig){
                    if(!typeSubTypeValues.contains(mappingConfigObj.Type__c+'-'+mappingConfigObj.SubType__c)){
                        mappingConfigObj.Active__c 	= false;
                        mappingConfigToDecativateList.add(mappingConfigObj);
                    }
                }
                if(!mappingConfigToDecativateList.isEmpty()) update mappingConfigToDecativateList;
            }
            
            
            List<Schema.SObjectField> mappingConfigFieldsList = FieldAccessibilityUtility.fetchMappingConfigFields();
            SecurityUtils.checkInsert(Mapping_Configurations__c.SObjectType,mappingConfigFieldsList);
            SecurityUtils.checkUpdate(Mapping_Configurations__c.SObjectType,mappingConfigFieldsList);
            upsert mappingConfigList Type_Subtype__c;
        }
        //Exception handling
        catch(Exception e){
            system.debug('Exception::::'+e.getLineNumber());
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('TypeAndSubtypeFetchAPI', 'typeAndSubtypeCallout', e);
            //throw new CustomException(errorMessage);
        }
        
    }
    
}