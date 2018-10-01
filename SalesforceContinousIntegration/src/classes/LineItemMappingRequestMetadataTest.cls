@IsTest
public class LineItemMappingRequestMetadataTest {
    
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
        insert iconMetadata1; 
        system.assertEquals('itemNumber', iconMetadata1.Field_Name__c);
        
        Value_Mapping__c vmpng = Utility_Test.valueMapping('itemNumber','Type1','SubType1','Test1','Description','Opportunity Product','abc');
        vmpng.IContract_Field_Metadata__c = iconMetadata1.id;
        insert vmpng;
        system.assertEquals('itemNumber', vmpng.Field_Name__c);
    }
    
    @isTest public static void executeTest(){
        
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        System.runAs(userObj){
            
            String jsonData = '[{"fieldName":"itemNumber","displayName":"Item Number","dataType":"String","length":"255","mandatory":"YES","allowedValues":"","defaultValue":"","applicableModules":"Repository,Authoring","lineItemRelationship":"ONE-ONE","isSelected":true}]';
            
            String mappingCreationJsonData = '[{"fieldName":"itemNumber","displayName":"itemNumber","dataType":"String","length":"255","mandatory":"YES","allowedValues":"","defaultValue":"","applicableModules":"Repository,Authoring","lineItemRelationship":"ONE-ONE","isSelected":true,"mappingField1":"Description","SOT":false,"mappingObject":"Opportunity Product"}]';            
            
            LineItemMappingRequestMetadata.Response rsp= new LineItemMappingRequestMetadata.Response();
            rsp.status = 'Success';
            rsp.statusCode =200;
            rsp.body ='';    
            LineItemMappingRequestMetadata.service();
            LineItemMappingRequestMetadata.getFieldsDetailsForParticularObject('Opportunity Product');
            LineItemMappingRequestMetadata.getContractAndSFFieldDataTypeMapping();
            LineItemMappingRequestMetadata.getObjectFieldSetUpURL('OpportunityLineItem','Theme4d');
            LineItemMappingRequestMetadata.getObjectFieldSetUpURL('IContract_MetaData__c','Theme4d');
            LineItemMappingRequestMetadata.getObjectFieldSetUpURL('OpportunityLineItem','Theme3d');
            LineItemMappingRequestMetadata.getObjectFieldSetUpURL('IContract_MetaData__c','Theme3d');
            LineItemMappingRequestMetadata.getObjectNameForLineItemMapping(); 
            LineItemMappingRequestMetadata.isDataExist();   
            LineItemMappingRequestMetadata.getExistingLineItemData(true);
            LineItemMappingRequestMetadata.getExistingLineItemData(false); 
            LineItemMappingRequestMetadata.createLineItemFieldsMetadata(jsonData); 
            LineItemMappingRequestMetadata.mappingObjectFieldForLineItemSelectedFields(mappingCreationJsonData);
            
            //Exception scenario
            try{
                LineItemMappingRequestMetadata.getFieldsDetailsForParticularObject(null);
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            //Exception scenario
            try{
                LineItemMappingRequestMetadata.getObjectFieldSetUpURL(null,'Theme 4d');
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            //Exception scenario
            try{
                LineItemMappingRequestMetadata.createLineItemFieldsMetadata(null);
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            //Exception scenario
            try{
                LineItemMappingRequestMetadata.mappingObjectFieldForLineItemSelectedFields(null);
            }
            Catch(Exception e){
                system.assertNotEquals(null, e.getMessage());
            }
            test.stopTest();    
        }
    }
}