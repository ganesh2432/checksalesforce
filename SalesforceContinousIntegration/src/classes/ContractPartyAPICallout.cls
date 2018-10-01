/*----------------------------------------------------------------------------
* Description :   This helper is used to make an http callout to ZYcus endpoint and get the CO data
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractPartyAPICallout {
    public static string finalResponse;
    
    //used to get the apiname of type val and use that apitypeval in callout as parameter
    public static Response getContractPartyData(String contracType,String searchText, Integer currentPage,boolean isOnload){
        
        Mapping_Configurations__c mappngConfig = [Select id,TypeName__c from Mapping_Configurations__c where Type__c=:contracType LIMIT 1];
        String requestBody = createRequestJsonData(mappngConfig.TypeName__c,searchText,currentPage,isOnload);
        if(requestBody!=null){
            return getContractPartyData(requestBody);
        } 
        return null;
    }  
    
    //used to create a json request body
    public static String createRequestJsonData(String contracTypeName, String searchText, Integer currentPage,boolean isOnload){
        try{
            
            ContractPartyRequest cpreq = new ContractPartyRequest();
            List<ContractPartyRequest.cls_criteria> cpCriteriaList = new List<ContractPartyRequest.cls_criteria>();
            ContractPartyRequest.cls_criteria cpCriteria1 = new ContractPartyRequest.cls_criteria();
            cpCriteria1.fieldName = Constants.CP_ContractType_criteria;      			  cpCriteria1.value = contracTypeName;
            cpCriteria1.operation = Constants.CP_ContractType_criteria_operation;         cpCriteria1.minValue = '';
            cpCriteria1.maxValue = '';        											  cpCriteriaList.add(cpCriteria1);
            
            if(!isOnload){
                ContractPartyRequest.cls_criteria cpCriteria2 = new ContractPartyRequest.cls_criteria();
                cpCriteria2.fieldName = Constants.CP_ContractType_criteria2;                  cpCriteria2.value = searchText;
                cpCriteria2.operation = Constants.CP_ContractType_criteria_operation2;        cpCriteria2.minValue = '';
                cpCriteria2.maxValue = '';       											  cpCriteriaList.add(cpCriteria2);
            }
            
            ContractPartyRequest.cls_criterias criterialistreq = new ContractPartyRequest.cls_criterias();
            criterialistreq.criteria =  cpCriteriaList;
            
            ContractPartyRequest.cls_pagination pagination = new ContractPartyRequest.cls_pagination();
            pagination.currentPage = ''+currentPage;
            pagination.perPage = Constants.CP_fetch_Number; 
            
            ContractPartyRequest.cls_search searchBody = new ContractPartyRequest.cls_search();
            searchBody.type = ''+constants.CP_search_condition_for_req;
            searchBody.pagination =   pagination; 
            searchBody.criterias =  criterialistreq;
            
            ContractPartyRequest.cls_integrationEntityDetails integrationentitydetail = new ContractPartyRequest.cls_integrationEntityDetails();
            integrationentitydetail.search =  searchBody;
            
            ContractPartyRequest.cls_integrationEntityHeader intrgEntHeader = new ContractPartyRequest.cls_integrationEntityHeader();
            intrgEntHeader.integrationTrackingNumber = constants.CP_integrationTrackingNumber; 
            intrgEntHeader.referenceCodeForEntity = ''; 
            
            List<ContractPartyRequest.cls_integrationEntity> intrgEntyList = new List<ContractPartyRequest.cls_integrationEntity>();
            
            ContractPartyRequest.cls_integrationEntity intrgEnty = new ContractPartyRequest.cls_integrationEntity();
            intrgEnty.integrationEntityDetails  = integrationentitydetail;
            intrgEnty.integrationEntityHeader =  intrgEntHeader;
            intrgEntyList.add(intrgEnty);
            
            ContractPartyRequest.cls_IntegrationEntities intrgEntities = new ContractPartyRequest.cls_IntegrationEntities();
            intrgEntities.integrationEntity =  intrgEntyList;
            
            cpreq.IntegrationEntities =  intrgEntities;
            
            
            return JSON.serialize(cpreq); 
        }Catch(Exception e){
            system.debug(e.getMessage());system.debug(e.getLineNumber());
            HandleBusinessException.captureError('ContractPartyAPICallout', 'createRequestJsonData', e);
            return null;
        }  
    }
    
    //callout to get CP data and return to lighting component
    public static Response getContractPartyData(String jsonRequestData){
        try{
            
            Zycus_API_Detail__mdt ApiDetails  =    [Select DeveloperName, Endpoint__c, Method__c, Timeout_Value__c,First_Header_Name__c,First_Header_Value__c,
                                                    Second_Header_Name__c,Second_Header_Value__c,Third_Header_Name__c,Third_Header_Value__c,Fourth_Header_Name__c,Fourth_Header_Value__c 
                                                    from Zycus_API_Detail__mdt
                                                    where DeveloperName=:Constants.ContractParty LIMIT 1];
            
            //Http callout 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(ApiDetails.Method__c);
            request.setEndpoint(ApiDetails.Endpoint__c);
            request.setHeader(ApiDetails.First_Header_Name__c, ApiDetails.First_Header_Value__c);
            request.setHeader(ApiDetails.Second_Header_Name__c, ApiDetails.Second_Header_Value__c);
            request.setHeader(ApiDetails.Third_Header_Name__c, ApiDetails.Third_Header_Value__c);
            request.setHeader(ApiDetails.Fourth_Header_Name__c, ApiDetails.Fourth_Header_Value__c);
            request.setBody(jsonRequestData);
            request.setTimeout(Integer.valueOf(ApiDetails.Timeout_Value__c));
            HttpResponse response = http.send(request);
            
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            system.debug('finalResponse:::::'+finalResponse);
            Response restRes 	= new Response();
            restRes.status 		= response.getStatus();
            restRes.statusCode 	= response.getStatusCode();
            restRes.body 		= finalResponse;   
            
            return restRes;    
            // return restRes;
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractPartyAPICallout', 'getContractPartyData', e);
            return null;
        }
    }
    
    //response wrapper
    public class Response {
        
        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
    }
    
}