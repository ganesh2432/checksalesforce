public class UpdateContractToIContractPayLoadService {
	
	public static void callUpdateContractAPI(List<PayLoad__c> payLoadList){
        Set<Id> contractIdSet   			= new Set<Id>();
        List<Contract> contractsToSendList	= new List<Contract>();
        for(PayLoad__c payLoadObj : payLoadList){
            if(String.isNotBlank(payLoadObj.Contract_Number__c)){
                if(payLoadObj.Contract_Number__c instanceof Id){
                    contractIdSet.add(payLoadObj.Contract_Number__c);
                }
            }
        }
        if(!contractIdSet.isEmpty()) contractsToSendList	= UpdateContractToIContractBatchModel.getContracts(contractIdSet);
        for(Contract contractObj : contractsToSendList){
            try{
                if(String.isBlank(contractObj.IContract_Id__c))
                    CreateContractAPICtrl.callCreateContract(contractObj.Id, null);
                else
                    UpdateContractAPICtrl.callUpdateContract(contractObj.Id, null);       
                }catch(Exception e){
            }
        }
    }
}