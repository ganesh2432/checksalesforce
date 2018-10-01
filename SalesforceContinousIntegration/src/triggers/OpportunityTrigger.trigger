trigger OpportunityTrigger on Opportunity (before insert, after update) {

    if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }    
}