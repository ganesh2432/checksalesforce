public class IContractMetaDataTriggerHelperModel {

    public static List<Mapping_Configurations__c> getMappingConfigDetail(Set<String> mappingConfigIdSet){
        return [Select Id, Last_Updated_On_Custom__c, Created_By_Custom__c
                from Mapping_Configurations__c where 
                Id IN: mappingConfigIdSet];
    }


    public static List<Mapping_Configurations__c> getMappingConfigDetailWithoutCreatedBy(Set<String> mappingConfigIdSet){
        return [Select Id, Last_Updated_On_Custom__c, Created_By_Custom__c
                from Mapping_Configurations__c where 
                Id IN: mappingConfigIdSet AND Created_By_Custom__c = null];
    }


    public static List<Mapping_Configurations__c> getMappingConfigDetailWithChildRec(Set<String> mappingConfigIdSet, List<IContract_MetaData__c> oldList){
        return [Select Id, Last_Updated_On_Custom__c, Created_By_Custom__c, 
        		(Select Id from IContract_Fields_Metadata__r where Id NOT IN: oldList)
                from Mapping_Configurations__c where 
                Id IN: mappingConfigIdSet];
    }
}