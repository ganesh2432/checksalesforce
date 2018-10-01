/*----------------------------------------------------------------------------
 * Description :   This controller for create CP API callout.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   15/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class ContractPartyCreationAPI {
	
    //Variable declaration
    public static string finalResponse;
    public static List<Contact> contactList;
    public static objFieldWrapper objFieldWrap;
    public static string successFailureResponse;
    
    //Method to call contract party creation API to send account details as Input
    //Contract number will be response.
    @AuraEnabled
    public static string contractPartyCreationCallout(String AccountId){
        try{
            
            //Prepare Request
            String Requestbody = ContractPartyCreationAPI.CreateCPRequest(AccountId);
           
            //callout class
            finalResponse = ContractPartyCreationAPICallOut.CPCreationAPICallOut(Requestbody,contactList);
        }
        catch(Exception e){
            
            //capture Error details
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ContractPartyCreationAPI', 'contractPartyCreationCallout', e);
        }
        system.debug('the final response'+finalResponse);
        return finalResponse;
    }
    
    //Generate JSON request from account object.
    public static string CreateCPRequest(String AccountId){
        
        //Query account and contact data
        Map<Account,List<Contact>> accountContactMap = ContractPartyCreationAPIModel.getAccountContactList(AccountId);
        CreateCPPartyJSONClass createCPRequest = new CreateCPPartyJSONClass();
        CreateCPPartyJSONClass.cls_IntegrationEntities integrationEntities  = new CreateCPPartyJSONClass.cls_IntegrationEntities();
        List<CreateCPPartyJSONClass.cls_integrationEntity> integrationEntityList = new List<CreateCPPartyJSONClass.cls_integrationEntity>();
        
        //Integration Header details
        CreateCPPartyJSONClass.cls_integrationEntityHeader integrationEntityHeader = new CreateCPPartyJSONClass.cls_integrationEntityHeader();
        integrationEntityHeader.integrationTrackingNumber = 'integrationTrackingNumber';
        integrationEntityHeader.referenceCodeForEntity ='';
        
        //Integration Entity Details
        CreateCPPartyJSONClass.cls_integrationEntityDetails integrationEntityDetails = new CreateCPPartyJSONClass.cls_integrationEntityDetails();
        //add contract party details
        CreateCPPartyJSONClass.cls_contractingParty contractingParty = new CreateCPPartyJSONClass.cls_contractingParty();
        set<Account> accSet = accountContactMap.keySet();
        List<Account> accList = new List<Account>();
        accList.addAll(accSet);
        contractingParty.legalName = accList[0].Name;
        contractingParty.externalId = accList[0].Id;
        //Add address details
        CreateCPPartyJSONClass.cls_addresses addresses = new CreateCPPartyJSONClass.cls_addresses();
        List<CreateCPPartyJSONClass.cls_addressDetails> addressDetailsList = new List<CreateCPPartyJSONClass.cls_addressDetails>();
        CreateCPPartyJSONClass.cls_contacts contacts = new CreateCPPartyJSONClass.cls_contacts();
        List<CreateCPPartyJSONClass.cls_contactDetails> contactDetailsList = new List<CreateCPPartyJSONClass.cls_contactDetails>();
        List<Contact> conList = accountContactMap.get(accList[0]);
        contactList = accountContactMap.get(accList[0]);
        for(contact con: conList){
            CreateCPPartyJSONClass.cls_contactDetails contactDetails = new CreateCPPartyJSONClass.cls_contactDetails();
            contactDetails.firstName = con.FirstName;
            contactDetails.lastName  = con.LastName;
            contactDetails.email     = con.Email;
            contactDetails.phone     = con.phone;
            contactDetailsList.add(contactDetails);
        }
        contacts.contactDetails = contactDetailsList;
        CreateCPPartyJSONClass.cls_addressDetails addressDetails = new CreateCPPartyJSONClass.cls_addressDetails();       
        addressDetails.contacts = contacts;
        addressDetailsList.add(addressDetails);
        addresses.addressDetails = addressDetailsList;
        contractingParty.addresses = addresses;
        //add integration entity details
        integrationEntityDetails.contractingParty = contractingParty;
        CreateCPPartyJSONClass.cls_integrationEntity integrationEntity = new CreateCPPartyJSONClass.cls_integrationEntity();
        integrationEntity.integrationEntityHeader = integrationEntityHeader;
        integrationEntity.integrationEntityDetails = integrationEntityDetails;
        integrationEntityList.add(integrationEntity);
        integrationEntities.integrationEntity = integrationEntityList;
        //add to CP Request
        createCPRequest.IntegrationEntities = integrationEntities;
        system.debug(JSON.serialize(createCPRequest));
        return JSON.serialize(createCPRequest);
    }
    
    //Wrapper to define structure objects & fields wrapper. 
    public class objFieldWrapper{
        @AuraEnabled
        public String legalName{get;set;}
        @AuraEnabled
        public String companyType{get;set;}
        @AuraEnabled
        public String externalId{get;set;}
        @AuraEnabled
        public String contractingPartyGsid{get;set;}
        @AuraEnabled
        public String address{get;set;}
    }
    
    //insert selected contract party
    @AuraEnabled
    public static string saveSelectedCP(String AccountId,String JsonobjFieldWrap){
        system.debug('Account id'+AccountId);
        objFieldWrap = (objFieldWrapper)System.JSON.deserialize(JsonobjFieldWrap, objFieldWrapper.Class);
        system.debug('wrap'+objFieldWrap);
        Account acc = new Account();
        acc.id = AccountId;
        acc.Contract_Party_ExternalId__c = objFieldWrap.externalId;
        acc.Contract_Party_CompanyName__c = objFieldWrap.companyType;
        acc.Contract_Party_contractingPartyGsid__c = objFieldWrap.contractingPartyGsid;
        acc.ContractParty_LegalName__c = objFieldWrap.legalName;
        acc.Contract_Party_address__c = objFieldWrap.address;
        
        try{
            update acc;
            successFailureResponse = 'Account Successfully updated';
        }
        Catch(Exception e){
            //capture Error details
            successFailureResponse = e.getMessage();
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ContractPartyCreationAPI', 'saveSelectedCP', e);
        }
        return successFailureResponse;
    }
}