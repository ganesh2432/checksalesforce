public class OpportunityTriggerHandler {

    public static void onAfterUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        OpportunityTriggerService.updateContractFields(newMap, oldMap);
    }
}