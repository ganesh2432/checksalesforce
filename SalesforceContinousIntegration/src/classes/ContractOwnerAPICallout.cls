/*----------------------------------------------------------------------------
* Description :   This helper is used to make an http callout to ZYcus endpoint and get the CO data
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractOwnerAPICallout {
    public static string finalResponse;
    
    //used to get the apiname of type val and use that apitypeval in callout as parameter
    public static Response getContractOwnerData(String contracType, String searchBy, String searchText, Integer currentPage,boolean isOnload){
        Mapping_Configurations__c mappngConfig = [Select id,TypeName__c from Mapping_Configurations__c where Type__c=:contracType LIMIT 1];
        String requestBody = createRequestJsonData(mappngConfig.TypeName__c,searchBy,searchText,currentPage,isOnload);
        if(requestBody!=null){
            return getContractPartyData(requestBody);
        } 
        return null;
    } 
    
    //used to create a json request body
    public static String createRequestJsonData(String contracTypeName, String searchBy, String searchText, Integer currentPage,boolean isOnload){
        try{
            ContractOwnerRequest conOwner = new ContractOwnerRequest();
            List<ContractOwnerRequest.cls_criteria> criteriaList = new List<ContractOwnerRequest.cls_criteria>();
            
            ContractOwnerRequest.cls_criteria conTypeCriteria = new ContractOwnerRequest.cls_criteria();
            
            conTypeCriteria.fieldName = Constants.CO_ContractType_criteria;        conTypeCriteria.value = contracTypeName;
            conTypeCriteria.operation = Constants.CO_ContractType_criteria_operation;        conTypeCriteria.minValue = '';
            conTypeCriteria.maxValue = '';        criteriaList.add(conTypeCriteria);
            
            if(!isOnload){
                ContractOwnerRequest.cls_criteria filterCriteria = new ContractOwnerRequest.cls_criteria();
                filterCriteria.fieldName = searchBy;                                            filterCriteria.value = searchText;
                filterCriteria.operation = Constants.CO_ContractType_criteria_2peration;        filterCriteria.minValue = '';
                filterCriteria.maxValue = '';                                                   criteriaList.add(filterCriteria);
            }
             
            ContractOwnerRequest.cls_criterias criterialistreq= new ContractOwnerRequest.cls_criterias();
            criterialistreq.criteria = criteriaList;
            
            ContractOwnerRequest.cls_pagination pagination = new ContractOwnerRequest.cls_pagination();
            pagination.currentPage = ''+currentPage;
            pagination.perPage = Constants.CO_fetch_Number;
            
            
            ContractOwnerRequest.cls_search searchBody= new ContractOwnerRequest.cls_search();
            searchBody.criterias = criterialistreq;
            searchBody.pagination = pagination;
            ContractOwnerRequest.cls_integrationEntityDetails integrationentitydetail= new ContractOwnerRequest.cls_integrationEntityDetails();
            integrationentitydetail.search = searchBody;
            
            ContractOwnerRequest.cls_integrationEntityHeader intrgEntHeader = new ContractOwnerRequest.cls_integrationEntityHeader();
            intrgEntHeader.integrationTrackingNumber = Constants.CO_IntegrationTracking_Num;
            intrgEntHeader.referenceCodeForEntity = '';
            
            List<ContractOwnerRequest.cls_integrationEntity> intrgEntyList = new List<ContractOwnerRequest.cls_integrationEntity>();
            ContractOwnerRequest.cls_integrationEntity intrgEnty = new ContractOwnerRequest.cls_integrationEntity();
            intrgEnty.integrationEntityDetails = integrationentitydetail;
            intrgEnty.integrationEntityHeader = intrgEntHeader;
            intrgEntyList.add(intrgEnty);
            
            ContractOwnerRequest.cls_IntegrationEntities intrgEntities = new ContractOwnerRequest.cls_IntegrationEntities();
            intrgEntities.integrationEntity = intrgEntyList;
            
            
            conOwner.IntegrationEntities = intrgEntities;
            
            
            return JSON.serialize(conOwner);
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractOwnerAPICallout', 'createRequestJsonData', e);
            return null;
        }
    } 
    
    //callout to get CO data and return to lighting component
    public static Response getContractPartyData(String jsonRequestData){
        try{
            
            Zycus_API_Detail__mdt ApiDetails  =    [Select DeveloperName, Endpoint__c, Method__c, Timeout_Value__c,First_Header_Name__c,First_Header_Value__c,
                                                    Second_Header_Name__c,Second_Header_Value__c,Third_Header_Name__c,Third_Header_Value__c,Fourth_Header_Name__c,Fourth_Header_Value__c 
                                                    from Zycus_API_Detail__mdt
                                                    where DeveloperName=:Constants.ContractOwner LIMIT 1];
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(ApiDetails.Method__c);
            request.setEndpoint(ApiDetails.Endpoint__c);
            request.setHeader(ApiDetails.First_Header_Name__c, ApiDetails.First_Header_Value__c);
            request.setHeader(ApiDetails.Second_Header_Name__c, ApiDetails.Second_Header_Value__c);
            request.setHeader(ApiDetails.Third_Header_Name__c, ApiDetails.Third_Header_Value__c);
            request.setHeader(ApiDetails.Fourth_Header_Name__c, ApiDetails.Fourth_Header_Value__c);
            request.setTimeout(Integer.valueOf(ApiDetails.Timeout_Value__c));
            request.setBody(jsonRequestData);
            HttpResponse response = http.send(request);
            
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            Response restRes 	= new Response();
            restRes.status 		= response.getStatus();
            restRes.statusCode 	= response.getStatusCode();
            restRes.body 		= finalResponse;   
            
            return restRes;    
            // return restRes;
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractOwnerAPICallout', 'getContractPartyData', e);
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