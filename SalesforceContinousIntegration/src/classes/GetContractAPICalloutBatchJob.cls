global class GetContractAPICalloutBatchJob implements Database.Batchable<sObject>, Database.Stateful,Schedulable,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){   
        String failureStatus = Constants.Failure_Status;
        Integer maxApiCalloutCount = Integer.valueOf(Constants.maxApiCalloutCount);
        String functiontype = Constants.FUNCTION_TYPE_GET_CONTRACT_PE;
        return Database.getQueryLocator('Select id,Contract_Number__c,Entity_Type__c,Event_Description__c,Event_Type__c from PayLoad__c where Status__c=:failureStatus and CalloutCount__c<=:maxApiCalloutCount and Function_Type__c=:functiontype');    
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new GetContractAPICalloutBatchJob(), 1); 
    }
    
    global void execute(Database.BatchableContext BC,List<PayLoad__c> payloadList){
        try{
            
            // only 1 record runs at a time but even then used forloop because not want to use index[0] which might change in future.
            for(PayLoad__c payld: payloadList){
                GetContractAPICalloutBatchJobHelper.calloutToGetcontractData(payld.Contract_Number__c,payld.Entity_Type__c,payld.Event_Description__c,payld.Event_Type__c);
            }
            
        }Catch(Exception e){
            HandleBusinessException.captureError('GetContractAPICalloutBatchJob', 'execute batch', e);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}