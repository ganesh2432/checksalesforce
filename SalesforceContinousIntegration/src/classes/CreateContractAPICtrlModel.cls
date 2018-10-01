public class CreateContractAPICtrlModel {

    public static List<PayLoad__c> getPayLoadRecord(String recordId, String functionType){
        return [Select Id, API_Request__c,API_Response__c, CalloutCount__c, Contract_Number__c, Entity_Type__c,
                Error_Message__c, Event_Description__c, Event_Type__c, Function_Type__c, Status__c
                from PayLoad__c 
                where Contract_Number__c =: recordId AND Function_Type__c =: functionType 
                LIMIT 1];
    }
}