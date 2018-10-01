@IsTest
public class RequestWizardTest {
    
    @testSetup static void createData(){        
        User dummyuser = Utility_Test.createUser('testdummyUser@zycustest.com');
        insert dummyuser;
        system.assertEquals('testdummyUser@zycustest.com', dummyuser.UserName);
        
        Mapping_Configurations__c  mapconfig = Utility_Test.createMappingConfig('Type1','SubType1');
        insert mapconfig;    
        system.assertEquals('Type1', mapconfig.Type__c);
        
        List<IContract_MetaData__c> iconMtdList = new List<IContract_MetaData__c>();
        IContract_MetaData__c iconMetadata1 = Utility_Test.createIconMetadata('Region','Type1','SubType1');
        iconMetadata1.Mapping_Configurations__c=mapconfig.id;    
        iconMtdList.add(iconMetadata1);  
        
        IContract_MetaData__c iconMetadata2 = Utility_Test.createIconMetadata('SubRegion','Type1','SubType1');
        iconMetadata2.Mapping_Configurations__c=mapconfig.id;    
        iconMtdList.add(iconMetadata2);   
        
        insert iconMtdList;
        system.assertNotEquals(null, iconMtdList);
        
    }
    
    @isTest public static void executeTest(){
        
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            RequestWizardHelper.getRequestWizardsMetadata('Type1','SubType1',false);
            Mapping_Configurations__c mpCongf = [Select id,Type__c,SubType__c from Mapping_Configurations__c where Type__c=:'Type1' and SubType__c=:'SubType1'];
            List<IContract_MetaData__c> iconMtdList = [Select id,Field_Name__c,Mandatory__c,Display_Name__c,Active__c,Mapping_Configurations__c from IContract_MetaData__c where Mapping_Configurations__c=:mpCongf.id];
            
            Request_Wizard_MetaData__c reqWizard = new Request_Wizard_MetaData__c(IContract_Field_Metadata__c=iconMtdList[0].id,Question__c='Specify the region',
                                                                                  Order_No__c=null,Type__c='Type1',SubType__c='SubType1',Mandatory__c=false,
                                                                                  Mandatory_in_Icontract__c=true,Field_Name__c='Region');    
            insert reqWizard;   
            RequestWizardController.getRequestWizardsMetadata('Type1','SubType1');
            
            //Exception scenario
            try{
               RequestWizardController.getRequestWizardsMetadata(null,null);//to cover catch block
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            
            RequestWizardController.SaveRequestWizard(new List<Request_Wizard_MetaData__c>{reqWizard});
            test.stopTest();    
        }
    }
    
}