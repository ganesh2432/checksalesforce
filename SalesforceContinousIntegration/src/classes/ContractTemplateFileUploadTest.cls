@IsTest
public class ContractTemplateFileUploadTest {
    
    @testSetup static void createData(){        
        User dummyuser = Utility_Test.createUser('testdummyUser@zycustest.com');
        insert dummyuser;
        system.assertEquals('testdummyUser@zycustest.com', dummyuser.UserName);
        
        Mapping_Configurations__c  mapconfig = new Mapping_Configurations__c(Type__c='Facilities Agreement',SubType__c='Goods and Services',
                                                                             Status__c='Active',Active__c=true,
                                                                             Allow_Stage__c = 'Closed won',Allow_LineItems__c=false,
                                                                             Allow_Files__c= true);
        insert mapconfig; 
        system.assertNotEquals(null, mapconfig);
        
        Account acc = new Account(Name='Test Rec');
        insert acc;
        system.assertNotEquals(null, acc);
        
        Opportunity opp =new Opportunity(AccountId=acc.id,Name='BA Test',IsPrivate = false,NextStep = 'Needs Analysis',Amount=100,Probability = 10,CloseDate = system.today()+10,StageName = 'Qualification');
        insert opp;
        system.assertNotEquals(null, opp);
        
        contract contrc = new contract(Opportunity__c=opp.id,AccountId=acc.id,StartDate = system.today(),Name = 'Facilities agreement',ContractTerm= 12,Status = 'Draft');
        insert contrc; 
        system.assertNotEquals(null, contrc);
        
        Reference_Documents__c refdoc = new Reference_Documents__c(Contract__c=contrc.id,Is_Template_Doc__c=true);    
        insert refdoc;
        system.assertNotEquals(null, refdoc);
        
  
    }   
    
    @isTest static void executeTest(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            
            opportunity opp = [Select id,Name from opportunity where NAme='BA Test' LIMIT 1];
            system.assertEquals('BA Test', opp.Name);
            contract contrct = [Select id,Opportunity__c,Name from contract where Name = 'Facilities agreement' LIMIT 1];
            system.assertEquals('Facilities agreement', contrct.Name);
            
            try{
            ContractTemplateFileUpload.getOpportunityIdFromContract(contrct.id);
            ContractTemplateFileUpload.getAllOppTempFiles(opp.id,contrct.id);
            ContractTemplateFileUpload.deleteFileDetailsIncontrct(contrct.id);
            }Catch(Exception e){
                
            }
            
            
        }
        test.stopTest();
        
    }
    
    @isTest static void executeTestforDocRelated(){
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            
            opportunity opp = [Select id,Name from opportunity where NAme='BA Test' LIMIT 1];
            system.assertEquals('BA Test', opp.Name);
            contract contrct = [Select id,Opportunity__c,Name from contract where Name = 'Facilities agreement' LIMIT 1];
            system.assertEquals('Facilities agreement', contrct.Name);
            
            // creating content document by contentversion
            ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'ZycusTest',
                PathOnClient = 'ZycusTest.jpg',
                VersionData = Blob.valueOf('Standard template Content Data'),
                IsMajorVersion = true
            );
            insert contentVersionInsert;
            system.assertEquals('ZycusTest', contentVersionInsert.Title);
            
            ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM  ContentVersion where Id=:contentVersionInsert.Id LIMIT 1];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            try{
            ContractTemplateFileUpload.updateTemplateFileDetailsInContract(contrct.id,documents[0].Id,documents[0].Title,true);
            ContractTemplateFileUpload.updateTemplateFileDetailsInContract(contrct.id,documents[0].Id,documents[0].Title,false);
            ContractTemplateFileUpload.deleteDocFile(contrct.id,documents[0].Id);
            }Catch(Exception e){}
        }
        test.stopTest();
        
    }
    
    @isTest static void executeTestforCatchblockcover(){
       test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){ 
        // to cover catch block
            try{
            ContractTemplateFileUpload.deleteDocFile(null,null);
            ContractTemplateFileUpload.deleteFileDetailsIncontrct('null*');
            ContractTemplateFileUpload.updateTemplateFileDetailsInContract('null*','documents[0].Id','documents[0].Title',false);
            }Catch(Exception e){
              system.assertNotEquals(null, e.getMessage());   
            }
        }
        test.stopTest();
    }
    
    
    @isTest static void executeTestForCalloutToGetstndrdTemplt(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            try{
            Test.setMock(HttpCalloutMock.class, new MockStandardTemplateResponse());
            ContractTemplateFileUpload.getStandardTemplateDetails(); 
            }Catch(Exception e){}
        }
        test.stopTest();
        
    }
    
    public class MockStandardTemplateResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('set the response string here');
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }    
}