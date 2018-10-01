public with sharing class TypeAndSubtypeFetchAPIModel {

    
    public static List<Mapping_Configurations__c> getAllExistingMappingConfigs(){
        return [Select Id, Type__c, SubType__c, Active__c 
                from Mapping_Configurations__c];
    }
}