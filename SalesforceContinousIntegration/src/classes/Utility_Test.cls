/* Description: Reusable methods for Test class
* 
*/
public class Utility_Test {
    
    /*
*@purpose    : get Test User record for Test Class
*@peturn Type: User
*/
    public static User createUser(string dummyusername){
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User dummyUser = new User(Alias = 'abcuser', Email='Zycusstandarduser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_IN', ProfileId = p.Id,TimeZoneSidKey='Asia/Kolkata',UserName=dummyusername);
        return dummyUser;
    }
    
    public static Mapping_Configurations__c createMappingConfig(String typ,String subTyp){
        return new Mapping_Configurations__c(Type__c=typ,SubType__c=subTyp,
                                             Status__c='Active',Active__c=true,
                                             Allow_Stage__c = 'Prospecting',Allow_LineItems__c=false,
                                             Allow_Files__c= true);
    }
    
    public static IContract_MetaData__c createIconMetadata(String fieldname,String typ,String subTyp){
        return new IContract_MetaData__c(Field_Name__c=fieldname,Mandatory__c=true,Display_Name__c=fieldname,
                                         Active__c=true);
    }
    
    public static Value_Mapping__c valueMapping(String fieldname,String typ,String subTyp,String iconVal,String mappingField,String MppngObj,String val){
        return new Value_Mapping__c(Field_Name__c=fieldname,Type__c=typ,IContract_Value__c=iconVal,
                                    SubType__c=subTyp,Mapping_Field__c=mappingField,Mapping_Object__c=MppngObj,Mapping_Value__c=val);
    }
    
     //Create Value Mapping data
    public static Value_Mapping__c createValueMapping(String FieldName, String IcmId, String iValue,
                                                      String field1, String object1, String value1,
                                                      String field2, String object2, String value2,
                                                      String externalid){
        Value_Mapping__c vm = new Value_Mapping__c();
        vm.Field_Name__c = FieldName;
        vm.IContract_Field_Metadata__c = IcmId;
        vm.IContract_Value__c = iValue;
        vm.Mapping_Field__c = field1;
        vm.Mapping_Object__c = object1;
        vm.Mapping_Value__c = value1;
        vm.Mapping_Field2__c =field2;
        vm.Mapping_Object2__c =object2;
        vm.Mapping_Value2__c =value2;
        vm.ValueMappingExternalID__c =externalid;
        return vm;
    }
    //Create MappingConfiguration data
    public static Mapping_Configurations__c createMapConfig(String Type,String SubType,String Status,
        String AllowStage, Boolean AllowLineItems, Boolean AllowFiles, Boolean Active,String externalId){
        Mapping_Configurations__c mapConfig = new Mapping_Configurations__c();
        mapConfig.Type__c = Type;
        mapConfig.SubType__c = SubType;
        mapConfig.Status__c = Status;
        mapConfig.Allow_Stage__c = AllowStage;
        mapConfig.Allow_LineItems__c = AllowLineItems;
        mapConfig.Allow_Files__c = AllowFiles;
        mapConfig.Active__c = Active;
        mapConfig.Type_Subtype__c = externalId;
        return mapConfig;
    }
    
    //Create IContractField Metadata
    public static IContract_MetaData__c createIContractFieldData(Boolean Active,String AllowedValues, String datatype, 
                                                                 String displayName, String FieldName, Boolean isLineItemActive,
                                                                 Boolean LineItemdata, Boolean Mandatory, String mapConfigId,
                                                                 String object1, String field1, String object2, String field2,
                                                                 String SOT){
        IContract_MetaData__c icm = new IContract_MetaData__c();
        icm.Active__c = Active;
        icm.AllowedValues__c = AllowedValues;
        icm.DataType__c = datatype;
        icm.Display_Name__c = displayName;
        icm.Field_Name__c = FieldName;
        icm.IsLineItemActive__c = isLineItemActive;
        icm.LineItem_Data__c = LineItemdata;
        icm.Mandatory__c = Mandatory;
        icm.Mapping_Configurations__c = mapConfigId;
        icm.Mapping_Object__c = object1;
        icm.Mapping_Field__c = field1;
        icm.Mapping_Object_2__c =object2;
        icm.Mapping_Field_2__c =field2;
        icm.SOT__c = SOT;
        return icm;
    }


    public static Product2 getProduct(){
        Product2 objProduct = new Product2();
        objProduct.Name = 'Zycus Product';
        objProduct.IsActive = true;
        return objProduct;
    }
    
    
    public static PricebookEntry createPricebookEntry (ID productId) {
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = Test.getStandardPricebookId();
        pbEntry.Product2Id = productId;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        return pbEntry;   
    }


    public static OpportunityLineItem createOpportunityLineItem (PricebookEntry pbEntry, String oppID) {
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppID;
        oli.Quantity = 1;
        oli.PricebookEntryId = pbEntry.Id;
        oli.TotalPrice = oli.Quantity * pbEntry.UnitPrice;
        return oli;
    }
    
    public static IContract_MetaData__c createIconMetadatas(String mapconfigid,String fieldname,String displyname,string datatype,string objecname,string objfield,string obj2name,string objfield2){
        return new IContract_MetaData__c(Active__c=true,Applicable_Module__c='Repository, Authoring',Field_Name__c = fieldname,Display_Name__c = displyname,
                                         DataType__c = datatype,Mapping_Object__c	 = objecname,
                                         Mapping_Field__c = objfield,Mapping_Object_2__c = obj2name,
                                         Mapping_Field_2__c = objfield2,Mapping_Configurations__c = mapconfigid);
    }
    
    public static Request_Wizard_MetaData__c createReqWizard(String fieldname,Map<String,String> geticntId,Integer orderno,String questn,String typeval,String subtypeval){
        
        return new Request_Wizard_MetaData__c(Field_Name__c=fieldname,IContract_Field_Metadata__c=geticntId.get(fieldname),Mandatory_in_Icontract__c=true,Order_No__c=orderno,Question__c=questn,Type__c=typeval,Subtype__c=subtypeval);
        
    }
    
    public static CreateContractGetDataHelper.DataToCreateContract createDataForContrctCreation(String fieldname,String fieldVal,String datatype){
        
        CreateContractGetDataHelper.DataToCreateContract  dataTocrtContrct= new CreateContractGetDataHelper.DataToCreateContract();
        dataTocrtContrct.FieldApiName=fieldname;
        dataTocrtContrct.FieldValue=fieldVal;
        dataTocrtContrct.dataType=datatype;
        return dataTocrtContrct;
        
    }
    
    public static List<CreateContractGetDataHelper.DataToCreateContract> createContractCreationDataFormat(){
        
        List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLst = new List<CreateContractGetDataHelper.DataToCreateContract>();
        dataTocrtContrctLst.add(createDataForContrctCreation('Name','Test contrct','text'));
        dataTocrtContrctLst.add(createDataForContrctCreation('ContractTerm','12','integer'));
        dataTocrtContrctLst.add(createDataForContrctCreation('StartDate',String.valueOf(System.today()),'date'));
        dataTocrtContrctLst.add(createDataForContrctCreation('Status','Draft','picklist'));
        dataTocrtContrctLst.add(createDataForContrctCreation('Last_update_from_Icontarct__c',String.valueOf(System.now()),'datetime'));
        dataTocrtContrctLst.add(createDataForContrctCreation('Is_RequestWizard_Contract__c','true','boolean'));
        return dataTocrtContrctLst;
    }
    
    public static List<CreateContractGetDataHelper.DataToCreateContract> createContractCreationDataFormatForwrng(){
        
        List<CreateContractGetDataHelper.DataToCreateContract>  dataTocrtContrctLst = new List<CreateContractGetDataHelper.DataToCreateContract>();
        dataTocrtContrctLst.add(createDataForContrctCreation('Status','Draft','multipicklist'));
        dataTocrtContrctLst.add(createDataForContrctCreation('ContractTerm','1','double'));
        return dataTocrtContrctLst;
    }


    public static PayLoad__c createPayLoadRecord(String contractId, String functionType, Integer calloutCount, String status){
        return new PayLoad__c(Contract_Number__c = contractId, Function_Type__c = functionType, CalloutCount__c = Decimal.valueOf(calloutCount), Status__c = status);
    }
}