public class CreateContractAPICtrl {
    
    public static CreateContractRespWrapper callCreateContract(String contractId, Contract contractSObj){
        return CreateContractAPICtrlService.callCreateContract(contractId, contractSObj);
    }

}