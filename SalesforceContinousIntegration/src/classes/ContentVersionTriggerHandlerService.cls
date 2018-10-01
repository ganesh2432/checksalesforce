public class ContentVersionTriggerHandlerService {

    public static void validateFileSize(List<ContentVersion> newList){
        File_Limits__c fileCSObj 	= File_Limits__c.getOrgDefaults();
        Decimal maxFileSize 		= fileCSObj.Max_File_Size_In_Bytes__c;
        if(maxFileSize != null){
            for(ContentVersion contentObj : newList){
                if(contentObj.ContentSize > maxFileSize){
                    contentObj.addError('Max File size allowed is : ' + maxFileSize + ' bytes.');
                }
            }
        }
    }
}