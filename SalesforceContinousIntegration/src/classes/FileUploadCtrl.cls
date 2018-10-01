/*
* @Author               : Rahul Sangwan
* Created By            : Rahul Sangwan (19/07/2018)
* Last Modified By      : Rahul Sangwan (11/09/2018)
* @Description          : Controller for Uploading Files for Contract
*/
public class FileUploadCtrl {

    transient static String existingBody;    
    
    /*
     * Purpose : To get Opportunity Id from Contract Record.
     */ 
    @AuraEnabled
    public static Id getOpportunityIdFromContract(String contractId){
        return FileUploadCtrlService.getOpportunityIdFromContract(contractId);
    }
    
    
    /*
     * Purpose : To get All files related to Contract record.
     */
    @AuraEnabled
    public static List<FileDetailsWrapper> getAllContractFiles(String contractId){
        return FileUploadCtrlService.getAllContractFiles(contractId);
    }
    
    
    /*
     * Purpose : To get All files related to Opportunity record.
     */
    @AuraEnabled
    public static List<FileDetailsWrapper> getAllOppFiles(String contractId){
        return FileUploadCtrlService.getAllContractFiles(contractId);
    }
    
    
    /*
     * Purpose : To copy Files from Opportunity to Contract.
     */
    @AuraEnabled
    public static String copyFilesToContract(String fileDetailsWrapList, String contractId){
        return FileUploadCtrlService.copyFilesToContract(fileDetailsWrapList, contractId);
    }
    
    
    /*
     * Purpose : To get All files related to Opportunity record.
     */
    @AuraEnabled
    public static List<FileDetailsWrapper> getAllOppFiles(String oppId, String contractId){
        return FileUploadCtrlService.getAllOppFiles(oppId, contractId);
    }
    
     
    /*
     *  Purpose : To delete File.
     */ 
    @AuraEnabled
    public static List<FileDetailsWrapper> deleteDocFile(String contractId, String documentId){
        return FileUploadCtrlService.deleteDocFile(contractId, documentId);
    }
    
    
    /*
     * Purpose : To create Reference Doc records for uploaded files in Contract.
     */
    @AuraEnabled
    public static void createRefDocList(List<String> fileIds, List<String> fileName, String contractId){
        FileUploadCtrlService.createRefDocList(fileIds, fileName, contractId);
    }
    

    /*
     * Purpose : To upload files from Classic view.
     */
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
            parentId    = null;
            fileName    = null;
            contentType = null;
            base64Data = null;
        } else {
            parentId    = null;
            fileName    = null;
            contentType = null;
            appendToFile(fileId, base64Data);
            base64Data = null;
        }
 
        return Id.valueOf(fileId);
    }
 
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {       
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion fileToattach = new ContentVersion(); 
        fileToattach.ContentLocation = 'S'; 
        fileToattach.PathOnClient = fileName ;
        fileToattach.Origin = 'H'; 
        fileToattach.Title = fileName;
        fileToattach.IsMajorVersion = false;       
        fileToattach.VersionData = EncodingUtil.base64Decode(base64Data);
        base64Data = null;//added by siva       
        insert fileToattach;
        fileToattach.VersionData =null;//added by siva
        ContentVersion contentDocIdOfFileAttached = [select ContentDocumentId from ContentVersion where Id =: fileToattach.Id LIMIT 1];
        ContentDocumentLink contentDocLink = new ContentDocumentLink(LinkedEntityId = parentId, 
                                                                     ContentDocumentId = contentDocIdOfFileAttached.ContentDocumentId, 
                                                                     ShareType = 'I');
        insert contentDocLink;       
        Reference_Documents__c refDocObj 		= new Reference_Documents__c();
        refDocObj.Contract__c					= parentId;
        refDocObj.File_Name__c					= fileName;
        refDocObj.File_URL__c					= contentDocIdOfFileAttached.ContentDocumentId;
        insert refDocObj;
        return fileToattach.Id;
    }
    

    @future
    private static void appendToFile(Id fileId, String base64Data) {         
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');               
        ContentVersion a = [
            SELECT Id, VersionData
            FROM ContentVersion
            WHERE Id =: fileId
        ];         
        existingBody        = EncodingUtil.base64Encode(a.VersionData);         
        a                   = new ContentVersion(Id = fileId);
        a.VersionData       = null;
        a.VersionData       = EncodingUtil.base64Decode(existingBody + base64Data);     
        existingBody        = null;
        base64Data =null;
        update a;
        a.VersionData = null;
    }

}