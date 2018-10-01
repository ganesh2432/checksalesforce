trigger ContentVersionTrigger on ContentVersion (before insert, after update, after insert) {

    
    if(Trigger.isInsert && Trigger.isAfter){
        ContentVersionTriggerHandler.onAfterInsert(trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        ContentVersionTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
    }
}