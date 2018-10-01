trigger iContractMetaData on IContract_MetaData__c (after insert, after update, after delete) {

	if(trigger.isInsert && trigger.isafter){
        IContractMetaDataTriggerHelper.onAfterInsert(Trigger.new);
     }


    if(trigger.isupdate && trigger.isafter){
        IContractMetaDataTriggerHelper.onAfterUpdate(Trigger.oldMap,Trigger.newMap);
     }


    if(trigger.isDelete && trigger.isafter){
        IContractMetaDataTriggerHelper.onAfterDelete(Trigger.old);
     }   
}