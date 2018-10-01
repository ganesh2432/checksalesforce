/*----------------------------------------------------------------------------
 * Description :   This controller to query data from DB.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   19/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class ContractPartyCreationAPICallOut {
	
    //Variable Declaration
    public static string finalResponse;
    public static string successFailureResponse;
    public static CreateCPPartySuccessJSONClass CPSuccess;
    public static CreateCPPartyFailedJSONClass CPFailure;
    public static List<CreateCPPartySuccessJSONClass.cls_integrationEntity> successIntegrationEntityList;
    public static CreateCPPartySuccessJSONClass.cls_integrationEntityDetails successIntegrationEntityDetails;
    public static List<CreateCPPartySuccessJSONClass.cls_addressDetails> successAddressesList;
    public static List<CreateCPPartySuccessJSONClass.cls_contactDetails> contactsList;
    
    public static List<CreateCPPartyFailedJSONClass.cls_integrationEntity> failureIntegrationEntityList;
    public static CreateCPPartyFailedJSONClass.cls_processingErrors failureprocessingErrors;
    public static List<CreateCPPartyFailedJSONClass.cls_error> errorList;
    
    //Method to call API callout
    public static string CPCreationAPICallOut(String RequestBody,List<Contact> conList){
        try{
            //Http callout 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/contractingParty/create');
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '9832');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(RequestBody);
            HttpResponse response = http.send(request);
            
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            system.debug('finalResponse:::::'+finalResponse);
            
            //Process response
            //Success response
            if(finalResponse.contains('SUCCESS')){
                CPSuccess = CreateCPPartySuccessJSONClass.parse(finalResponse);
                successIntegrationEntityList = CPSuccess.IntegrationEntities.integrationEntity;
                
                //Loop through Integration Entity List
                for(CreateCPPartySuccessJSONClass.cls_integrationEntity integrationEntity:successIntegrationEntityList){
                    successIntegrationEntityDetails = integrationEntity.integrationEntityDetails;
                    successAddressesList =integrationEntity.integrationEntityDetails.addresses.addressDetails;
                }
                //upsert value mapping data
            	List<Schema.SObjectField> accountFieldsList = FieldAccessibilityUtility.accountFields();
            	SecurityUtils.checkUpdate(Account.SObjectType,accountFieldsList);
                List<Schema.SObjectField> contactFieldsList = FieldAccessibilityUtility.contactFields();
            	SecurityUtils.checkUpdate(contact.SObjectType,contactFieldsList);
                //update account
                Account acc = new Account();
                acc.id = successIntegrationEntityDetails.externalId;
                acc.Contract_Party_ExternalId__c = successIntegrationEntityDetails.id;               
                //Get address details
                for(CreateCPPartySuccessJSONClass.cls_addressDetails addressDetail:successAddressesList){
                    contactsList = addressDetail.contacts.contactDetails;
                }
                //Loop through contact details
                for(CreateCPPartySuccessJSONClass.cls_contactDetails contactDetails : contactsList){
                    
                }
                List<Contact> updateConList = new List<Contact>();
                for(Integer i=0; i<conList.size();i++){
                    contact con = new contact();
                    con.id = conList[i].Id;
                    con.IContract_Contact_Id__c = String.valueOf(contactsList[i].contactId);
                    updateConList.add(con);
                }
                
                //update Account and Contact
                try{
                    update acc;
                    update updateConList;
                }
                catch(Exception e){
                    
                    //capture Error details
            		String errorMessage = e.getMessage();
            		HandleBusinessException.captureError('ContractPartyCreationAPICallOut', 'CPCreationAPICallOut', e);
                }
                successFailureResponse = 'SUCCESS';
            }
            //Failure Response
            else{
                CPFailure = CreateCPPartyFailedJSONClass.parse(finalResponse);
                failureIntegrationEntityList = CPFailure.IntegrationEntities.integrationEntity;
                
                //Loop through Integration Entity List
                for(CreateCPPartyFailedJSONClass.cls_integrationEntity integrationEntity:failureIntegrationEntityList){
                    errorList = integrationEntity.processingErrors.error;
                }
                //Loop through error data
                for(CreateCPPartyFailedJSONClass.cls_error error:errorList){
                    successFailureResponse = error.errorDescription;
                }
            }
            
        }
        Catch(Exception e){
            //capture Error details
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ContractPartyCreationAPICallOut', 'CPCreationAPICallOut', e);
        }
        return successFailureResponse;
    }
}