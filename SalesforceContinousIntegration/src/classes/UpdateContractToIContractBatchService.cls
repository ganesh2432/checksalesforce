public class UpdateContractToIContractBatchService {
	
	public static void callUpdateContractAPI(List<Contract> contractsToSendList){
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