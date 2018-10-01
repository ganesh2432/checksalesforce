/***********************************************************************************************
Author : Siva Krishna Reddy B
Purpose : This is the class is used to define test data.
Created Date : 30/05/2018
Lastmodified By : 
Reason: 
*****************************************************************************************************/
public class IntializeTestData {
    
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
}