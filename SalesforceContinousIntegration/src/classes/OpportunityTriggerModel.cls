public class OpportunityTriggerModel {

    public static List<Contract> getRelatedContractsOfOpp(Set<Id> opportunityIdSet){
         String query   = Utility.getDynamQuery('Contract', 'Opportunity__c IN: opportunityIdSet'); 
         return  Database.query(query);
    }
    
    
    public static List<IContract_MetaData__c> getAllIContractMetadata(){
        return [Select Id, Mapping_Object__c, Mapping_Object_2__c, SOT__c, Mapping_Field__c, Mapping_Field_2__c,
                Mapping_Configurations__c, Mapping_Configurations__r.Type__c, Mapping_Configurations__r.SubType__c
                from IContract_MetaData__c
                where SOT__c =: Constants.SOT_SALESFORCE AND Mapping_Field_2__c != null AND Mapping_Field__c != null];
    }
}