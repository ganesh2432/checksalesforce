public class ContentVersionTriggerHandler {
    
    public static void onAfterInsert(List<ContentVersion> newList){
        ContentVersionTriggerHandlerService.validateFileSize(newList);
    }
    
    
    public static void onAfterUpdate(Map<Id, ContentVersion> newMap, Map<Id, ContentVersion> oldMap){
        ContentVersionTriggerHandlerService.validateFileSize(newMap.values());
    }

}