public class ContractTriggerHandlerService {

    public static void checkAndUpdateContractInIContract(Map<Id, Contract> newMap, Map<Id, Contract> oldMap){
        List<Contract> contractsToSendList	= new List<Contract>();
        contractsToSendList					= checkValidContractsToSend(newMap, oldMap, contractsToSendList);
        Integer contractListSize 			= 0;
        if(!contractsToSendList.isEmpty())	contractListSize = contractsToSendList.size();
        if(contractListSize < 10){
            callUpdateContractAPI(contractsToSendList);
        }else{
            List<Contract> contractsToSendLimitedList	= new List<Contract>();
            for(Integer i = 0; i < 10; i++){
                contractsToSendLimitedList.add(contractsToSendList[i]);
            }
            callUpdateContractAPI(contractsToSendLimitedList);
        }
    }
    
    
    static List<Contract> checkValidContractsToSend(Map<Id, Contract> newMap, Map<Id, Contract> oldMap, List<Contract> contractsToSendList){
        List<String> statusList 			= (Constants.NON_EDITED_CONTRACT_STATUSES).split(',');
        for(String contractId : newMap.keySet()){
            if(newMap.get(contractId).Update_from_Opportunity__c == true && 
               oldMap.get(contractId).Update_from_Opportunity__c == false &&
               !statusList.contains(newMap.get(contractId).IContract_Status__c)){
                contractsToSendList.add(newMap.get(contractId));
            }
        }
        return contractsToSendList;
    }
    
    
    static void callUpdateContractAPI(List<Contract> contractsToSendList){
        for(Contract contractObj : contractsToSendList){
            if(System.Limits.getLimitCallouts() > 0){
                try{
                    if(String.isBlank(contractObj.IContract_Id__c))
                        CreateContractAPICtrl.callCreateContract(null, contractObj);
                    else
                        UpdateContractAPICtrl.callUpdateContract(null, contractObj);       
                    }catch(Exception e){
                }
            }
        }
    }
}