@isTest
public class ObjectBasedFieldMappingControllerTest {

    @testSetup static void createData(){
	     User auser = Utility_Test.createUser('testdummy@zycustest.com');
         insert auser;
         Basic_Authentication__c ba = new Basic_Authentication__c(Username__c = 'test', Password__c = 'test', Application_Id__c = 'test');
		 insert ba;        
    }
    
    
    @isTest static void testmethod1(){
        User userObj 	= [Select Id from User where UserName = 'testdummy@zycustest.com'];
        Mapping_Configurations__c configObj 	= Utility_Test.createMappingConfig('Test 1', 'Test 2');
        insert configObj;
        String objectMappingStr 				= '[{"fieldName":"maxRenewal","displayName":"Maximum Number of Renewals (Remaining)","dataType":"Integer"},{"fieldName":"isContractConfidential","displayName":"Is Contract Confidential?","dataType":"list"},{"fieldName":"isConfidentialContractSearchable","displayName":"Is Confidential Contract Searchable?","dataType":"radio"},{"fieldName":"BU Address","displayName":"Address","dataType":"TEXT_AREA"},{"fieldName":"Code","displayName":"Code","dataType":"String"},{"fieldName":"Contract_Title","displayName":"Contract Title","dataType":"String"},{"fieldName":"Facilities_Section","displayName":"Facilities Section","dataType":"list"},{"fieldName":"Contract_Value","displayName":"Contract Value","dataType":"BigDecimal"},{"fieldName":"Region","displayName":"Region","dataType":"list"},{"fieldName":"Base_Currency","displayName":"Currency","dataType":"list"},{"fieldName":"Payment_Term","displayName":"Payment Terms","dataType":"list"},{"fieldName":"Contract_Category","displayName":"Contract Category","dataType":"list"},{"fieldName":"Contract_Effective_Date","displayName":"Contract Start Date","dataType":"Date"},{"fieldName":"Contract_Expiration_Date","displayName":"Contract End Date","dataType":"Date"},{"fieldName":"Contract_Owner","displayName":"Buyer Email","dataType":"String"},{"fieldName":"Insurance_Reviewer","displayName":"Insurance Reviewer","dataType":"String"},{"fieldName":"Performance_Bond_Amount","displayName":"Performance Bond Amount","dataType":"BigDecimal"},{"fieldName":"Bond_Currency","displayName":"Performance Bond Currency","dataType":"list"},{"fieldName":"Business_Units","displayName":"Business Unit","dataType":"String"},{"fieldName":"Status1","displayName":"Status","dataType":"list"},{"fieldName":"Contract_Status","displayName":"Contract Status","dataType":"list"},{"fieldName":"Heirarchy_Status","displayName":"Hierarchy Status","dataType":"list"},{"fieldName":"Folder","displayName":"Folder","dataType":"list"},{"fieldName":"TIMEZONE","displayName":"Contract Timezone","dataType":"list"},{"fieldName":"AUTO_RENEW","displayName":"Is Evergreen","dataType":"list"},{"fieldName":"renewalNotice","displayName":"Renewal Notice (Days)","dataType":"Integer"},{"fieldName":"renewalPeriod","displayName":"Renewal Period (Months)","dataType":"Integer"},{"fieldName":"Business__Contact_2","displayName":"Business  Contact 2","dataType":"String"},{"fieldName":"Business__Contact_1","displayName":"Business  Contact 1","dataType":"String"},{"fieldName":"Contract_Renewal_Date","displayName":"Contract Review Date","dataType":"Date"},{"fieldName":"Contract_Signing_Date","displayName":"Contract Signed On","dataType":"Date"},{"fieldName":"Additional_Information_1","displayName":"Additional Information 1","dataType":"TEXT_AREA"},{"fieldName":"Additional_Information_2","displayName":"Additional Information 2","dataType":"TEXT_AREA"},{"fieldName":"Additional_Information_3","displayName":"Additional Information 3","dataType":"TEXT_AREA"}]';
        Test.startTest();
        System.runAs(userObj){
            List<String> objectList     = ObjectBasedFieldMappingController.getObjectsLabels();
            System.assert(objectList.size() > 0);
            Map<String, FieldsForObjectRespWrapper> oppObjFields    =   ObjectBasedFieldMappingController.getFieldsDetailsForParticularObject('Opportunity');
            System.assert(oppObjFields.values().size() > 0);
            Map<String, List<String>> objectsToMap                  =   ObjectBasedFieldMappingController.getObjectsToMapFromCM();
            System.assert(!objectsToMap.isEmpty());
            Map<String, String> sfAndIContractMapping               =   ObjectBasedFieldMappingController.getContractAndSFFieldDataTypeMapping();
            System.assert(oppObjFields.values().size() > 0);
            ObjectBasedFieldMappingController.getObjectFieldSetUpURL('Opportunity', 'Theme4d');
            ObjectBasedFieldMappingController.getObjectFieldSetUpURL('Opportunity', 'Theme3');
            ObjectBasedFieldMappingController.getObjectFieldSetUpURL('IContract_MetaData__c', 'Theme4d');
            ObjectBasedFieldMappingController.getObjectFieldSetUpURL('IContract_MetaData__c', 'Theme3');
            Map<String, IContract_MetaData__c> metadatRecMap    =   ObjectBasedFieldMappingController.getMetadataRecords(configObj.Id);
            System.assert(metadatRecMap.values().isEmpty());
            String result   =   ObjectBasedFieldMappingController.saveIcontractRecords(objectMappingStr, configObj.Id, 'Contract', 'Opportunity');
            System.assert(result == 'SUCCESS');
        }
        Test.stopTest();
    }
}