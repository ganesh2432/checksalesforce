/*----------------------------------------------------------------------------
* Description :   This class is used to get standard template details from zycus 
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractStandardTemplateCalloutHelper {
    
    public static String stndrdTmpltResponse;
    
    public static Response getStandardTemplateDetails(){
        try{
            
        // getting endpoint details from custom metadata    
         Zycus_API_Detail__mdt ApiDetails  =    [Select DeveloperName, Endpoint__c, Method__c, Timeout_Value__c,First_Header_Name__c,First_Header_Value__c,Second_Header_Name__c,Second_Header_Value__c 
                                                 from Zycus_API_Detail__mdt
                                                 where DeveloperName=:Constants.StandardTemplate LIMIT 1];
            
        //Http callout 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(ApiDetails.Method__c);
        request.setEndpoint(ApiDetails.Endpoint__c);
        request.setHeader(ApiDetails.First_Header_Name__c, ApiDetails.First_Header_Value__c);
        request.setHeader(ApiDetails.Second_Header_Name__c, ApiDetails.Second_Header_Value__c);
        request.setTimeout(Integer.valueOf(ApiDetails.Timeout_Value__c));
        HttpResponse response = http.send(request);
        stndrdTmpltResponse = response.getBody();
            
            Response restRes 	= new Response();
            restRes.status 		= response.getStatus();
	        restRes.statusCode 	= response.getStatusCode();
            restRes.body 		= stndrdTmpltResponse;
            
            
        return restRes;
        }Catch(Exception e){
            system.debug(e.getMessage() +'@@@'+e.getLineNumber());
            HandleBusinessException.captureError('ContractStandardTemplateCalloutHelper', 'getStandardTemplateDetails', e);
            return null;
        }
    }
    
    //response
        public class Response {

        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
    }
}