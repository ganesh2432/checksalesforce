@isTest
public class TypeSubtypeControllerTest {

    
    @testSetup static void createData(){
	     User auser = Utility_Test.createUser('testdummy@zycustest.com');
         insert auser;
         Basic_Authentication__c ba = new Basic_Authentication__c(Username__c = 'test', Password__c = 'test', Application_Id__c = 'test');
		 insert ba;        
    }
    
    
    @isTest static void getTypeAndSubTypeMaptestmethod1(){
        Test.setMock(HttpCalloutMock.class, new TypeSubTypeMockHttpResponseGenerator());
        User userObj 	= [Select Id from User where UserName = 'testdummy@zycustest.com'];
        Test.startTest();
        System.runAs(userObj){
         	TypeSubtypeController.getTypeAndSubTypeMap();   
            List<Mapping_Configurations__c> mappingConfigList   = [Select Id from Mapping_Configurations__c];
            System.assert(mappingConfigList.size() > 0);
        }
        Test.stopTest();
    }
    
    
    @isTest static void getTypeAndSubTypeMaptestmethod2(){
        Test.setMock(HttpCalloutMock.class, new TypeSubTypeMockHttpResponseGenerator());
        User userObj 				= [Select Id from User where UserName = 'testdummy@zycustest.com'];
        Basic_Authentication__c ba 	= Basic_Authentication__c.getOrgDefaults();
        delete ba;
        Test.startTest();
        System.runAs(userObj){
            try{
                TypeSubtypeController.getTypeAndSubTypeMap();    
            }catch(Exception e){
                system.debug('e::::'+e.getMessage());
            }
            List<Mapping_Configurations__c> mappingConfigList   = new List<Mapping_Configurations__c>();
            mappingConfigList                                   = [Select Id from Mapping_Configurations__c];
            System.assert(mappingConfigList.size() > 0);
        }
        Test.stopTest();
    }
}