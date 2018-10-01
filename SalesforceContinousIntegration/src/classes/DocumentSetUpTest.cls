@IsTest
public class DocumentSetUpTest {
    
    
    @testSetup static void createData(){        
        User dummyuser = Utility_Test.createUser('testdummyUser@zycustest.com');
        insert dummyuser;
        system.assertEquals('testdummyUser@zycustest.com', dummyuser.UserName);
        
        Mapping_Configurations__c  mapconfig = new Mapping_Configurations__c(Type__c='Type1',SubType__c='SubType1',
                                                                             Status__c='Active',Active__c=true,
                                                                             Allow_Stage__c = 'Prospecting',Allow_LineItems__c=false,
                                                                             Allow_Files__c= true);
        insert mapconfig;    
        system.assertEquals('Type1', mapconfig.Type__c);
    }
    
    @isTest static void executeTest(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            DocumentSetUpController.getPicklistValues('Opportunity','StageName');    
            
            //Exception scenario
            try{
              DocumentSetUpController.getPicklistValues('Opportunity',null); // To cover catch block
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            
            
            String documentSetupWrpAsString ='';
            String docSetupwrpstr = '';    
            DocumentSetupWrapper docSetupWrp = new DocumentSetupWrapper();
            docSetupWrp.types = 'PROCUREMENT';	//PROCUREMENT
            docSetupWrp.subType = 'PURCHASEORDER';	//PURCHASEORDER
            docSetupWrp.allowedStage = 'Value Proposition';	//Value Proposition
            docSetupWrp.storeFiles = true;
            docSetupWrp.allowLineItem = true;    
            documentSetupWrpAsString = System.JSON.serialize(docSetupWrp);
            docSetupWrp.types = 'Type1';
            docSetupWrp.subType = 'SubType1';  
            docSetupwrpstr = System.JSON.serialize(docSetupWrp);
            
            ActivateWrapper actwrp = new ActivateWrapper();    
            actwrp.types = 'Type1';
            actwrp.subType = 'SubType1';
            actwrp.activateMappingconfig = 'Active';
            
            DocumentSetUpController.getMppingConfigForTypeAndSubType('Type1','SubType1');     
            DocumentSetUpController.createMappingConfigurations(documentSetupWrpAsString); // for insert   
            DocumentSetUpController.createMappingConfigurations(docSetupwrpstr);// for update
            //Exception scenario
            try{
              DocumentSetUpController.createMappingConfigurations(null); //to cover catch block  
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            DocumentSetUpController.activateMappingConfigurations(system.json.serialize(actwrp));
             //Exception scenario
            try{
              DocumentSetUpController.activateMappingConfigurations(null); //to cover cathc block  
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            test.stopTest();    
        }
    }
}