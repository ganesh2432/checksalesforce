public with sharing class ObjectBasedFieldMappingControllerModel {

    public static List<Object_Mapping_Record__mdt> getObjectToMapRecList(){
        return [Select Id, Object_Type__c, MasterLabel, DeveloperName 
                from Object_Mapping_Record__mdt];
    }
    
    
    public static List<System_Fields__mdt> getSystemFieldsList(){
        return [Select Id, MasterLabel, DeveloperName 
                from System_Fields__mdt];
    }
    
    
    public static List<IContract_MetaData__c> getMetadataOfConfigList(String mapConfigId){
        return [Select Id, Field_Name__c, Mapping_Field__c, Mapping_Object__c, Mapping_Field_2__c, 
                Mapping_Object_2__c, Display_Name__c, DataType__c , Active__c, SOT__c
                from IContract_MetaData__c
                where Mapping_Configurations__c =: mapConfigId
                AND Active__c = true];
    }
    
    
    public static List<Icontract_and_Salesforce_Field_Mapping__mdt> getContractAndSfDataTypeMapping(){
        return [Select Id, DeveloperName, MasterLabel, Salesforce_Field_Datatype__c 
                from Icontract_and_Salesforce_Field_Mapping__mdt
                ];
    }
}