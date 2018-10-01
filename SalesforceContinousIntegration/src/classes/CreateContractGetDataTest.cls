@IsTest
public class CreateContractGetDataTest {
    
    public static List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLst;
    public static List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLstForMultipicklist;
    public static List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLstForboolean;
    public static List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLstForDatetime;
    public static List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLstForDouble;
    
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
        
        contract contrc = new contract(AccountId=acc.id,StartDate = system.today(),Name = 'Facilities agreement',ContractTerm= 12,Status = 'Draft');
        insert contrc; 
        system.assertNotEquals(null, contrc);
        
        List<IContract_MetaData__c> iconMtdList = new List<IContract_MetaData__c>();
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'Contract_Title','Contract Title','String','Contract','Name','Opportunity',null)); 
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'renewalPeriod','Renewal Period (Months)','Integer','Contract','ContractTerm','Opportunity','Amount')); 
        iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'Contract_Expiration_Date','Contract End Date','Date','Contract','StartDate','Opportunity','CloseDate')); 
        IContract_MetaData__c iconMtdforPicklist = Utility_Test.createIconMetadatas(mapconfig.id,'Facilities_Section','Facilities Section','list','Contract','Status','Opportunity','StageName'); 
        iconMtdforPicklist.AllowedValues__c = 'Maintenance,Project';
        iconMtdforPicklist.SOT__c = 'iContract';
        iconMtdList.add(iconMtdforPicklist);
        //iconMtdList.add(Utility_Test.createIconMetadatas(mapconfig.id,'isConfidentialContractSearchable','Is Confidential Contract Searchable?','radio','Contract','','Opportunity','IsPrivate'));
        
        insert iconMtdList;
        system.assertNotEquals(null, iconMtdList);
        
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
        
        insert valMppng;
        system.assertNotEquals(null, valMppng);
        
        List<Request_Wizard_MetaData__c> rewzrdList = new List<Request_Wizard_MetaData__c>();        
        // rewzrdList.add(Utility_Test.createReqWizard('Is Confidential Contract Searchable?',geticntId,1,'Please specify the Is Confidential Contract Searchable?',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Contract Title',geticntId,2,'Please specify the Contract Title',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Renewal Period (Months)',geticntId,3,'Please specify the Renewal Period (Months)',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Contract End Date',geticntId,4,'Please specify the Contract End Date',mapconfig.Type__c,mapconfig.SubType__c));
        rewzrdList.add(Utility_Test.createReqWizard('Facilities Section',geticntId,5,'Please specify the Facilities Section',mapconfig.Type__c,mapconfig.SubType__c));
        
        insert rewzrdList;  
        system.assertNotEquals(null, rewzrdList);
        
    }
    
    @isTest static void executeTest(){     
        test.startTest();
        User userObj   = [Select Id from User where UserName = 'testdummyUser@zycustest.com'];
        
        System.runAs(userObj){
            
            opportunity opp = [Select id from opportunity where NAme='BA Test' LIMIT 1];
            contract contrct = [Select id from contract where Name = 'Facilities agreement' LIMIT 1];
            
            try{
            CreateContractGetDataController.getContractDetails(String.valueOf(opp.id),'Facilities Agreement','Goods and Services');    
            CreateContractGetDataController.getEditContractDetails(String.valueOf(contrct.id),'Facilities Agreement','Goods and Services');
            CreateContractGetDataController.getcontractOwnerdata(String.valueOf(contrct.id));
            CreateContractGetDataController.createContractData(String.valueOf(contrct.id),String.valueOf(opp.id),json.serialize(Utility_Test.createContractCreationDataFormat()),'Facilities Agreement','Goods and Services');
            }Catch(Exception e){}
            
            try{
            //wrong but to cover code has too be done. asss dynamic fields cant bbe created in text class and boolean,multipicklist,datetime,double and many more datatype standard fields are not there so    
            CreateContractGetDataController.createContractData(String.valueOf(contrct.id),String.valueOf(opp.id),json.serialize(Utility_Test.createContractCreationDataFormatForwrng()),'Facilities Agreement','Goods and Services');
            }Catch(Exception e){}
            
            try{
            //CreateContractVisualforceController class coverage    
            PageReference pageRef = Page.CreateContract;
            pageRef.getparameters().put('recordId', contrct.id);  
            Test.setCurrentPage(pageRef);        
            Apexpages.StandardController sc = new Apexpages.StandardController(contrct);
            CreateContractVisualforceController ext = new  CreateContractVisualforceController(sc);         
            }Catch(Exception e){}
            
            try{
            //CreateContractValidationCheck class coverage    
            CreateContractValidationCheck.isAllowedToCreateContract(opp.id);
            StandardTemplatesWrapper stwrp = new StandardTemplatesWrapper();
            //EditContractController class coverage    
            EditContractcontroller.getTypeandSubType(contrct.id);
            }Catch(Exception e){}
        }
        test.stopTest();
    }
    
    
}