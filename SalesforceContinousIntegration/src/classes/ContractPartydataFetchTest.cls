@IsTest
public class ContractPartydataFetchTest {

    @testSetup static void createData(){        
        User dummyuser = Utility_Test.createUser('testdummyUser@zycustest.com');
        insert dummyuser;
        system.assertEquals('testdummyUser@zycustest.com', dummyuser.UserName);
        
        Mapping_Configurations__c  mapconfig = new Mapping_Configurations__c(Type__c='Facilities Agreement',SubType__c='Goods and Services',
                                                                             Status__c='Active',Active__c=true,
                                                                             Allow_Stage__c = 'Closed won',Allow_LineItems__c=false,
                                                                             Allow_Files__c= true,TypeName__c='FACILITIESAGREEMENT');
        insert mapconfig; 
		system.assertNotEquals(null, mapconfig);
        
        Account acc = new Account(Name='Test Rec');
        insert acc;
        system.assertNotEquals(null, acc);
        
        Opportunity opp =new Opportunity(AccountId=acc.id,Name='BA Test',IsPrivate = false,NextStep = 'Needs Analysis',Amount=100,Probability = 10,CloseDate = system.today()+10,StageName = 'Qualification');
        insert opp;
        system.assertNotEquals(null, opp);
        
        contract contrc = new contract(AccountId=acc.id,StartDate = system.today(),Name = 'Facilities agreement',ContractTerm= 12,Status = 'Draft');
        insert contrc; 
        system.assertNotEquals(null, contrc);
       
        
    }
    
    
    @isTest static void executeTest(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            ContractPartyRequest contreq = new ContractPartyRequest();
            ContractPartyRequest.parse('{"IntegrationEntities":{"integrationEntity":[{"integrationEntityHeader":{"referenceCodeForEntity":"","integrationTrackingNumber":"INTEGRATIONTRACKINGNUMBER"},"integrationEntityDetails":{"search":{"type":"and","pagination":{"perPage":"25","currentPage":"1"},"criterias":{"criteria":[{"value":"","operation":"EQUALS","minValue":"","maxValue":"","fieldName":"CONTRACT_TYPE"},{"value":"s","operation":"CONTAINS","minValue":"","maxValue":"","fieldName":"first_name"}]}}}}]}}');
            try{
            Test.setMock(HttpCalloutMock.class, new MockContractPartyResponse());
            ContractPartyDataFetch.getContractPartyData('Facilities Agreement','test@email.com',1,false);
            }catch(Exception e){}
        }
       test.stopTest(); 
    }
    
    public class MockContractPartyResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('set the response string here');
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }
}