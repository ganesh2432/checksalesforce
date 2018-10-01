@ISTest
public class LightningCreateContractPrgsIndtrTest {
    
    @testSetup static void createData(){        
        User dummyuser = Utility_Test.createUser('testdummyUser@zycustest.com');
        insert dummyuser;
        system.assertEquals('testdummyUser@zycustest.com', dummyuser.UserName);
        
        Mapping_Configurations__c  mapconfig = new Mapping_Configurations__c(Type__c='Facilities Agreement',SubType__c='Goods and Services',
                                                                             Status__c='Active',Active__c=true,
                                                                             Allow_Stage__c = 'Closed won',Allow_LineItems__c=false,
                                                                             Allow_Files__c= true);
        insert mapconfig; 
        
        Account acc = new Account(Name='Test Rec');
        insert acc;
        
        Opportunity opp =new Opportunity(AccountId=acc.id,Name='BA Test',IsPrivate = false,NextStep = 'Needs Analysis',Amount=100,Probability = 10,CloseDate = system.today()+10,StageName = 'Qualification');
        insert opp;
        
        contract contrc = new contract(AccountId=acc.id,StartDate = system.today(),Name = 'Facilities agreement',ContractTerm= 12,Status = 'Draft');
        insert contrc; 
        
        Reference_Documents__c refDoc = new Reference_Documents__c(Contract__c=contrc.id,Is_Template_Doc__c=true);
        
        insert refDoc;
        
    }
    
    @isTest static void executeTest(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        opportunity opp = [Select id from opportunity where NAme='BA Test' LIMIT 1];
        contract contrct = [Select id from contract where Name = 'Facilities agreement' LIMIT 1];
        
        System.runAs(userObj){
            LightningCreateContractPrgsIndtr.redirect(opp.id);
            LightningCreateContractPrgsIndtr.isLineItemAllowed('Facilities Agreement','Goods and Services');
            LightningCreateContractPrgsIndtr.deleteContract(contrct.id);
        }
        
        test.stopTest();   
    }
    
}