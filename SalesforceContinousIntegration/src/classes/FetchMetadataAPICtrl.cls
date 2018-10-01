public with sharing class FetchMetadataAPICtrl {

    //Variable Declaration
    public static string finalResponse;
    public static List<TypeAndSubtypeJSONClass.cls_type> typeAndSubtypeList; 
    public static TypeAndSubtypeJSONClass JSONstrcture;
    public static List<TypeAndSubtypeJSONClass.cls_integrationEntity> integrationEntityList;
    public static Map<String, List<String>> typeandSubTypeMap;
    public static List<TypeAndSubtypeJSONClass.cls_subType> subTypeList;
    public static List<Mapping_Configurations__c> mappingConfigList;
    
    //Get Method
    //Method to call type and SubType API to fetch type and subtype details.
    //    @AuraEnabled
    public static Response getFieldMetadataCallout(){
        
        try{
            
            //Http callout 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/metadata');
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '12345');
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            //Process response
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            system.debug('finalResponse:::::'+finalResponse);
            Response restRes 	= new Response();
            restRes.status 		= response.getStatus();
	        restRes.statusCode 	= response.getStatusCode();
            restRes.body 		= finalResponse;
            return restRes;
        }catch(Exception e){
         	return null;   
        }
    }
    
    
    public class Response {

        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
    }
}