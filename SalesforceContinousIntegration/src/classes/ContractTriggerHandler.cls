public class ContractTriggerHandler {
    
    public static Boolean afterUpdateCalled = false;
    
    public static void onAfterUpdate(Map<Id, Contract> newMap, Map<Id, Contract> oldMap){
        if(afterUpdateCalled == false){
         	ContractTriggerHandlerService.checkAndUpdateContractInIContract(newMap, oldMap);   
            afterUpdateCalled	= true;
        }
    }

}