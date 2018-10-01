public class UpdateContractAPICtrl {
	
	public static CreateContractRespWrapper callUpdateContract(String contractId, Contract contractSObj){
        return UpdateContractAPICtrlService.callUpdateContract(contractId, contractSObj);
    }
}