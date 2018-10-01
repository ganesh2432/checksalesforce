@IsTest
public class LineItemValueMappingTest {
    
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
        
        IContract_MetaData__c iconMetadata1 = Utility_Test.createIconMetadata('itemNumber','Type1','SubType1');
        iconMetadata1.Mapping_Configurations__c=mapconfig.id;   
        iconMetadata1.LineItem_Data__c =true;
        iconMetadata1.IsLineItemActive__c=true;
        iconMetadata1.DataType__c = 'List';
        iconMetadata1.Mapping_Field__c = 'Description'; 
        iconMetadata1.AllowedValues__c = 'al1,al2';    
        insert iconMetadata1;    
        system.assertEquals('itemNumber', iconMetadata1.Field_Name__c);
        
        List<Value_Mapping__c> vmpList = new List<Value_Mapping__c>();   
        Value_Mapping__c vmpng = Utility_Test.valueMapping('itemNumber','Type1','SubType1','Test1','Description','Opportunity Product','abc');
        vmpng.IContract_Field_Metadata__c = iconMetadata1.id;
        vmpList.add(vmpng);
        
        Value_Mapping__c unmppdVmpng = Utility_Test.valueMapping('itemNumber','Type1','SubType1','','','Opportunity Product','abc');
        unmppdVmpng.IContract_Field_Metadata__c = iconMetadata1.id;
        unmppdVmpng.Mapping_Field2__c = 'Stage';
        unmppdVmpng.Mapping_Object2__c = 'Opportunity';
        vmpList.add(unmppdVmpng);    
        
        insert vmpList;
        system.assertNotEquals(null, vmpList);
    }
    
    @isTest public static void executeTest(){
        
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        System.runAs(userObj){
            Mapping_Configurations__c mpCongf = [Select id,Type__c,SubType__c from Mapping_Configurations__c where Type__c=:'Type1' and SubType__c=:'SubType1'];
            List<IContract_MetaData__c> iconMtdList = [Select id,Field_Name__c,Mandatory__c,Display_Name__c,Active__c,Mapping_Configurations__c from IContract_MetaData__c where Mapping_Configurations__c=:mpCongf.id];
            List<Value_Mapping__c> vmpngList = [Select id,IContract_Field_Metadata__c,Mapping_Field2__c,Mapping_Object2__c,Field_Name__c,Type__c,IContract_Value__c,
                                                SubType__c,Mapping_Field__c,Mapping_Object__c,Mapping_Value__c From Value_Mapping__c where  IContract_Field_Metadata__r.Mapping_Configurations__c=:mpCongf.id];
            
            
            LineItemValueMapping.getIContractFields();
            LineItemValueMapping.getSelectedFieldsValuesFromIcontractAndSalesforce(System.label.Opportunity_Product,'Stage',new List<String>{'al1','al2','al3'},'itemNumber');
            LineItemValueMapping.getSelectedFieldsValuesFromIcontractAndSalesforce('Opportunity','StageName',new List<String>{'al1','al2','al3'},'itemNumber');
            //Exception scenario
            try{
                LineItemValueMappingHelper.getLineItemFieldsForValueMapping(null);
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            //Exception scenario
            try{
                LineItemValueMapping.saveValueMapping(null);
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            LineItemValueMapping.saveValueMapping(vmpngList);
            LineItemValueMapping.isAllValueMappingComplete(iconMtdList,false);    
            
            iconMtdList[0].AllowedValues__c = 'al1,al2,al3';    
            update iconMtdList[0];    
            LineItemValueMapping.isAllValueMappingComplete(iconMtdList,false);   
            test.stopTest();    
        }
    }
}