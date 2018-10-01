@isTest
private class OpportunityTriggerTest {
	
	@testSetup
    static void createData() { 
    	Account accObj 	= new Account(Name = 'test');
    	insert accObj;
    	Opportunity oppObj 	= new Opportunity(AccountId = accObj.Id, StageName = 'Prospecting',
    										  Name = 'test', CloseDate = Date.today());
    	insert oppObj;
    	Product2 prod = Utility_Test.getProduct();
        insert prod;
        PricebookEntry pBookEntry = Utility_Test.createPricebookEntry(prod.id);
        insert pBookEntry;
    	OpportunityLineItem oppLineItem = Utility_Test.createOpportunityLineItem(pBookEntry, oppObj.id);
        insert oppLineItem;
        Contract contractObj 	= new Contract(AccountId = accObj.Id, Opportunity__c = oppObj.Id, Type__c='Facilities Agreement',SubType__c='Goods and Services', Allow_Opportunity_LineItem_s__c = true, StartDate = Date.today(), Name = 'test');
        insert contractObj;

        Mapping_Configurations__c  mapconfig = new Mapping_Configurations__c(Type__c='Facilities Agreement',SubType__c='Goods and Services',
                                                                             Status__c='Active',Active__c=true,
                                                                             Allow_Stage__c = 'Closed won',Allow_LineItems__c=false,
                                                                             Allow_Files__c= true);
        insert mapconfig;

        List<IContract_MetaData__c> iconMtdList = new List<IContract_MetaData__c>();
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'Contract_Title','Contract Title','String','Contract','Name','Opportunity',null)); 
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'renewalPeriod','Renewal Period (Months)','Integer','Contract','ContractTerm','Opportunity','Amount')); 
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'Contract_Expiration_Date','Contract End Date','Date','Contract','StartDate','Opportunity','CloseDate')); 
        
        IContract_MetaData__c iconMtdforPicklist = Utility_Test.createIconMetadatas(mapconfig.id,'Facilities_Section','Facilities Section','list','Contract','Status','Opportunity','Name'); 
        iconMtdforPicklist.AllowedValues__c = 'Maintenance,Project';
        iconMtdforPicklist.SOT__c = Constants.SOT_SALESFORCE;
        iconMtdList.add(iconMtdforPicklist);
        //iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'isConfidentialContractSearchable','Is Confidential Contract Searchable?','radio','Contract','','Opportunity','IsPrivate'));
        
        insert iconMtdList;

        IContract_MetaData__c metadataObj1 = Utility_Test.createIconMetadatas(mapconfig.id,'Id','Id','String','Contract','Id','Opportunity','Id');
        metadataObj1.Is_Dependent_Field__c = true;
        metadataObj1.Dependant_Fields__c = 'Id';
        insert metadataObj1;
        system.debug(iconMtdList);
        
        List<IContract_MetaData__c> iconPickList = [Select id,Display_Name__c,Mapping_Configurations__r.Type__c,Mapping_Configurations__r.Subtype__c,Field_Name__c,Mapping_Object__c,Mapping_Field__c,Mapping_Field_2__c,Mapping_Object_2__c from IContract_MetaData__c where Mapping_Configurations__c=:mapconfig.id];
        
        Map<string,String> geticntId = new Map<String,String>();
        IContract_MetaData__c iconPickLsit = new IContract_MetaData__c();
        for(IContract_MetaData__c iconmt :  iconPickList){
            geticntId.put(iconmt.Display_Name__c,iconmt.id);
            if(iconmt.Field_Name__c=='Facilities_Section'){
            iconPickLsit = iconmt;
            }
        }
        
        List<Value_Mapping__c> valMppng = new List<Value_Mapping__c>();
        Value_Mapping__c vmpng1 = new Value_Mapping__c(IContract_Field_Metadata__c=iconPickLsit.id,Field_Name__c=iconPickLsit.Field_Name__c,
                                                     Mapping_Object__c =iconPickLsit.Mapping_Object__c ,Mapping_Field__c =iconPickLsit.Mapping_Field__c ,Mapping_Value__c ='Qualification' ,
                                                     Mapping_Object2__c = iconPickLsit.Mapping_Object_2__c,Mapping_Field2__c =iconPickLsit.Mapping_Field_2__c , Mapping_Value2__c = '	Draft',
                                                     IContract_Value__c ='Maintenance' ,Type__c= iconPickLsit.Mapping_Configurations__r.Type__c,SubType__c = iconPickLsit.Mapping_Configurations__r.Subtype__c);
        valMppng.add(vmpng1);
        Value_Mapping__c vmpng2 = new Value_Mapping__c(IContract_Field_Metadata__c=iconPickLsit.id,Field_Name__c=iconPickLsit.Field_Name__c,
                                                     Mapping_Object__c =iconPickLsit.Mapping_Object__c ,Mapping_Field__c =iconPickLsit.Mapping_Field__c ,Mapping_Value__c ='Prospecting' ,
                                                     Mapping_Object2__c = iconPickLsit.Mapping_Object_2__c,Mapping_Field2__c =iconPickLsit.Mapping_Field_2__c , Mapping_Value2__c = '	In Approval Process',
                                                     IContract_Value__c ='Project' ,Type__c= iconPickLsit.Mapping_Configurations__r.Type__c,SubType__c = iconPickLsit.Mapping_Configurations__r.Subtype__c);
       valMppng.add(vmpng2); 

        Value_Mapping__c vmpng3 = new Value_Mapping__c(IContract_Field_Metadata__c=metadataObj1.id,Field_Name__c=iconPickLsit.Field_Name__c,
                                                     Mapping_Object__c =iconPickLsit.Mapping_Object__c ,Mapping_Field__c =iconPickLsit.Mapping_Field__c ,Mapping_Value__c =contractObj.Id ,
                                                     Mapping_Object2__c = iconPickLsit.Mapping_Object_2__c,Mapping_Field2__c =iconPickLsit.Mapping_Field_2__c , Mapping_Value2__c = contractObj.Id,
                                                     IContract_Value__c =contractObj.Id ,Type__c= iconPickLsit.Mapping_Configurations__r.Type__c,SubType__c = iconPickLsit.Mapping_Configurations__r.Subtype__c);
       valMppng.add(vmpng3); 

        insert valMppng;
       
        system.debug(valMppng);
		List<Request_Wizard_MetaData__c> rewzrdList = new List<Request_Wizard_MetaData__c>();        
       // rewzrdList.add(Utility_Test.createReqWizard('Is Confidential Contract Searchable?',geticntId,1,'Please specify the Is Confidential Contract Searchable?',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Contract Title',geticntId,2,'Please specify the Contract Title',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Renewal Period (Months)',geticntId,3,'Please specify the Renewal Period (Months)',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Contract End Date',geticntId,4,'Please specify the Contract End Date',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Facilities Section',geticntId,5,'Please specify the Facilities Section',mapconfig.Type__c,mapconfig.SubType__c));
        
      insert rewzrdList;

      	Create_Contract_Params__c paramCSObj = new Create_Contract_Params__c(Endpoint__c = 'www.test.com', Tenant_Id__c = '1233', Tracking_Number__c = '1234', Content_Type__c = 'json', Username__c = 'test', Update_API_Endpoint__c = 'www.test.com');
      	insert paramCSObj;

      	insert Utility_Test.createPayLoadRecord(contractObj.Id, Constants.Function_Type_CREATE_CONTRACT_SF, 1, Constants.PAYLOAD_STATUS_FAILURE);
     }


	@isTest static void test_method_one() {
		Opportunity oppObj = [Select Id, Name from Opportunity LIMIT 1];
		Test.startTest();
		oppObj.Name 	= 'test1233';
		update oppObj;
		Test.stopTest();
	}
	
}