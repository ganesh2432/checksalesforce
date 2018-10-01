public class UpdateContractToIContractBatchModel {
	
	public static List<Contract> getContracts(Set<Id> contractIdSet){
		List<String> statusList       = (Constants.NON_EDITED_CONTRACT_STATUSES).split(',');
		return [Select Id, IContract_Id__c 
				from Contract 
				where Id IN: contractIdSet AND IContract_Status__c NOT IN: statusList];
	}
}