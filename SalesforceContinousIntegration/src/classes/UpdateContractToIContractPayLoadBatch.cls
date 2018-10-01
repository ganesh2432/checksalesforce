global class UpdateContractToIContractPayLoadBatch implements Database.Batchable<sObject> {
	
	String query;
	String failureStatus;
	Integer maxApiCalloutCount;
	String functiontype;

	global UpdateContractToIContractPayLoadBatch() {
		failureStatus = Constants.PAYLOAD_STATUS_FAILURE;
        maxApiCalloutCount = Integer.valueOf(Constants.maxApiCalloutCount);
        functiontype = Constants.Function_Type_CREATE_CONTRACT_SF;
        query = 'Select id,Contract_Number__c,API_Request__c,API_Response__c,Function_Type__c, Error_Message__c, CalloutCount__c from PayLoad__c where Status__c=:failureStatus and CalloutCount__c<=:maxApiCalloutCount and Function_Type__c=:functiontype';    
	}

	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}


   	global void execute(Database.BatchableContext BC, List<PayLoad__c> scope) {
		try{
			UpdateContractToIContractPayLoadService.callUpdateContractAPI(scope);
		}catch(Exception e){}
	}

	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}