/*----------------------------------------------------------------------------
 * Description :   This controller to used to define fields of mapping 
 *                 configuration object.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   03/05/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class FieldAccessibilityUtility {
    
    public static List<Schema.SObjectField> fetchMappingConfigFields() {

        List<Schema.SObjectField> mappingConfigurationFieldsList = new List<Schema.SObjectField>{
            Mapping_Configurations__c.SObjectType.fields.Type__c,
            Mapping_Configurations__c.SObjectType.fields.SubType__c};            
        return mappingConfigurationFieldsList;
    }
    
    public static List<Schema.SObjectField> fetchValueMappingFields(){
        List<Schema.SObjectField> valueMappingFieldsList = new List<Schema.SObjectField>{
            Value_Mapping__c.SObjectType.fields.Field_Name__c,
            Value_Mapping__c.SObjectType.fields.IContract_Value__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Object__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Field__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Value__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Object2__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Field2__c,
            Value_Mapping__c.SObjectType.fields.Mapping_Value2__c,
            Value_Mapping__c.SObjectType.fields.IContract_Field_Metadata__c};            
        return valueMappingFieldsList;
    }
    
    public static List<Schema.SObjectField> fetchMappingConfigurationFields() {

        List<Schema.SObjectField> mappingConfigurationFieldsList = new List<Schema.SObjectField>{
            Mapping_Configurations__c.SObjectType.fields.Type__c,
            Mapping_Configurations__c.SObjectType.fields.SubType__c,
            Mapping_Configurations__c.SObjectType.fields.Type_Subtype__c,
            Mapping_Configurations__c.SObjectType.fields.Active__c,
            Mapping_Configurations__c.SObjectType.fields.Allow_Stage__c,
            Mapping_Configurations__c.SObjectType.fields.Allow_LineItems__c,
            Mapping_Configurations__c.SObjectType.fields.Allow_Files__c,
            Mapping_Configurations__c.SObjectType.fields.Stage__c};            
        return mappingConfigurationFieldsList;
    }
    
    public static List<Schema.SObjectField> requestWizardFields() {

        List<Schema.SObjectField> requestWizardFieldsList = new List<Schema.SObjectField>{
            Request_Wizard_MetaData__c.SObjectType.fields.Type__c,
            Request_Wizard_MetaData__c.SObjectType.fields.SubType__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Order_No__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Mandatory_in_Icontract__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Field_Name__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Mandatory__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Question__c,
            Request_Wizard_MetaData__c.SObjectType.fields.IContract_Field_Metadata__c,
            Request_Wizard_MetaData__c.SObjectType.fields.IsRequired__c,
            Request_Wizard_MetaData__c.SObjectType.fields.Mandatory_in_Icontract__c};            
        return requestWizardFieldsList; 
    }
    
    public static List<Schema.SObjectField> icontractMetadatafields(){
        List<Schema.SObjectField> icontractMetadataFieldsList = new List<Schema.SObjectField>{
            IContract_MetaData__c.SObjectType.fields.Field_Name__c,
            IContract_MetaData__c.SObjectType.fields.Display_Name__c,
            IContract_MetaData__c.SObjectType.fields.DataType__c,
            IContract_MetaData__c.SObjectType.fields.AllowedValues__c,
            IContract_MetaData__c.SObjectType.fields.Default_Value__c,
            IContract_MetaData__c.SObjectType.fields.Applicable_Module__c,
            IContract_MetaData__c.SObjectType.fields.Contract_Relationship__c,
            IContract_MetaData__c.SObjectType.fields.Dependant_Fields__c,
            IContract_MetaData__c.SObjectType.fields.LineItem_Data__c,
            IContract_MetaData__c.SObjectType.fields.IsLineItemActive__c,
            IContract_MetaData__c.SObjectType.fields.Length__c,
            IContract_MetaData__c.SObjectType.fields.Mandatory__c};
        return icontractMetadataFieldsList;    
    }
    
    public static List<Schema.SObjectField> accountFields(){
        List<Schema.SObjectField> accountFieldsList = new List<Schema.SObjectField>{
            Account.SObjectType.fields.Contract_Party_ExternalId__c};            
        return accountFieldsList;
    }
    public static List<Schema.SObjectField> contactFields(){
        List<Schema.SObjectField> contactFieldsList = new List<Schema.SObjectField>{
            contact.SObjectType.fields.IContract_Contact_Id__c};            
        return contactFieldsList;
    }

}