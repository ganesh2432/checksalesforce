trigger ContractTrigger on Contract (before insert, after update) {

    
    if(Trigger.isUpdate && Trigger.isAfter){
        ContractTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}