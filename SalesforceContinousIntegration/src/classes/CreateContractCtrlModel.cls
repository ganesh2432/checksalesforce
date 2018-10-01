public class CreateContractCtrlModel {
    
    public static List<Create_Contract_API_Mapping__mdt> getContractMappingCMList(){
        return [Select Id, DeveloperName, MasterLabel, Mapping_Contract_Field__c, Type__c
                from Create_Contract_API_Mapping__mdt];
    }
    
    
    public static List<IContract_MetaData__c> getMetadataList(String type, String subType, Set<String> contractMappingFieldSet){
        return [Select Id, Mapping_Field_2__c, Field_Name__c, Mapping_Field__c,
                (Select Id, Mapping_Value__c, IContract_Value__c from Value_Mappings__r) 
                from IContract_MetaData__c
                where Mapping_Configurations__r.Type__c =: type And 
                Mapping_Configurations__r.SubType__c =: subType And
                Field_Name__c IN: contractMappingFieldSet And
                Mapping_Object__c = 'Contract'];
    }
    
    
    public static List<IContract_MetaData__c> getMetadataList(String type, String subType){
        return [Select Id, Mapping_Field_2__c, Field_Name__c, Mapping_Field__c ,
                (Select Id, Mapping_Value__c, IContract_Value__c from Value_Mappings__r)
                from IContract_MetaData__c
                where Mapping_Configurations__r.Type__c =: type And 
                Mapping_Configurations__r.SubType__c =: subType And
                Is_Dependent_Field__c = false And
                Mapping_Object__c = 'Contract'];
    }
    
    
    public static List<IContract_MetaData__c> getDependentMetadataList(String type, String subType){
        return [Select Id, Mapping_Field_2__c, Field_Name__c , Dependant_Fields__c,Mapping_Field__c,
                (Select Id, Mapping_Value__c, IContract_Value__c from Value_Mappings__r)
                from IContract_MetaData__c
                where Mapping_Configurations__r.Type__c =: type And 
                Mapping_Configurations__r.SubType__c =: subType And
                Is_Dependent_Field__c = true And
                Dependant_Fields__c != null And
                Mapping_Object__c = 'Contract'];
    }
    
    
    public static Account getAccountDetailsForContract(String accountId){
        return [Select Id, Contract_Party_ExternalId__c, ContractParty_LegalName__c
                from Account where Id =:accountId];
    }
    
    
    public static List<OpportunityLineItem> getLineItemsForContract(String oppId){
        return [Select Id, Quantity, Description, ProductCode, UnitPrice, Units_of_Measurement__c, Price_Type__c, Currency__c
                from OpportunityLineItem 
                where OpportunityId =: oppId];
    }

}