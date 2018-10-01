global class UpdateContractToIContractBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
	
	String query;
	
	global UpdateContractToIContractBatch() {
		query 	= 'Select Id, IContract_Status__c, IContract_Id__c from Contract where Update_from_Opportunity__c = true';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Contract> scope) {
		UpdateContractToIContractBatchService.callUpdateContractAPI(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}