/*
* @Author               : Rahul Sangwan
* Created By            : Rahul Sangwan (19/07/2018)
* Last Modified By      : Rahul Sangwan (11/09/2018)
* @Description          : Service class for FileUploadCtrl.
*/
public class FileUploadCtrlService {
    
    /*
     * Purpose : To get Opportunity Id from Contract Record.
     */
    public static Id getOpportunityIdFromContract(String contractId){
        return FileUploadCtrlModel.getOpportunityIdFromContract(contractId);
    }
    

    /*
     * Purpose : To get All files related to Opportunity record.
     */
    public static List<FileDetailsWrapper> getAllOppFiles(String oppId, String contractId){
        Map<Id, ContentDocument> contentDocMap;
        List<ContentDocumentLink> contentDocLinkList 	= new List<ContentDocumentLink>();
        List<FileDetailsWrapper> fileDetWrapList	 	= new List<FileDetailsWrapper>();        
        List<String> contentDocIdList 					= new List<String>();
        List<ContentVersion> fileList 					= new List<ContentVersion>(); 
        List<Reference_Documents__c> refDocList 		= new List<Reference_Documents__c>();
        Set<String> contentDocumentIdSet 				= new Set<String>();
        
        contentDocLinkList 								= FileUploadCtrlModel.getContentDocListFromParentId(oppId);
        try{
            refDocList									= FileUploadCtrlModel.getReferenceDocForContract(contractId);
            for(Reference_Documents__c refDocObj : refDocList){
                if(String.isNotBlank(refDocObj.File_URL__c)) contentDocumentIdSet.add(refDocObj.File_URL__c);
            }
        }catch(DmlException e){}
         catch(Exception e){}
        
        for(ContentDocumentLink contentDocObj : contentDocLinkList){
            contentDocIdList.add(contentDocObj.ContentDocumentId);
        }
        
        contentDocMap 					= FileUploadCtrlModel.getContentDocDetailsList(contentDocIdList);
        
        fileList 						= FileUploadCtrlModel.getFileDetailsList(contentDocIdList);
        
        for(ContentVersion fileObj : fileList){
            String fileType 	= (fileObj.PathOnClient).remove(fileObj.Title + '.');
            Boolean isSelected	= false;
            if(contentDocumentIdSet.contains(fileObj.ContentDocumentId))
                isSelected		= true;
            String fileSize 	= Utility.convertFromByte(fileObj.ContentSize);
            FileDetailsWrapper wrapObj 	= new FileDetailsWrapper(isSelected, fileObj.ContentDocumentId,fileObj.Title, fileType, contentDocMap.get(fileObj.ContentDocumentId).CreatedDate, contentDocMap.get(fileObj.ContentDocumentId).Owner.Name);
            wrapObj.fileSize	= fileSize;
            fileDetWrapList.add(wrapObj);
        }
        return fileDetWrapList;
    }
    
    
    /*
     * Purpose : To get All files related to Contract record.
     */
    public static List<FileDetailsWrapper> getAllContractFiles(String contractId){
        Map<Id, ContentDocument> contentDocMap;
        List<ContentDocumentLink> contentDocLinkList 	= new List<ContentDocumentLink>();
        List<FileDetailsWrapper> fileDetWrapList	 	= new List<FileDetailsWrapper>();        
        List<String> contentDocIdList 					= new List<String>();
        List<ContentVersion> fileList 					= new List<ContentVersion>(); 
        Contract contractObj 							= new Contract();
        
        contractObj										= FileUploadCtrlModel.getContractDetails(contractId);
        
        contentDocLinkList 								= FileUploadCtrlModel.getContentDocListFromParentId(contractId);
        
        for(ContentDocumentLink contentDocObj : contentDocLinkList){
            String str = contentDocObj.ContentDocumentId;
            if(!str.equalsIgnoreCase(contractObj.Template_DocumentId__c))
            contentDocIdList.add(contentDocObj.ContentDocumentId);
        }
        
        contentDocMap 					= FileUploadCtrlModel.getContentDocDetailsList(contentDocIdList);
        
        fileList 						= FileUploadCtrlModel.getFileDetailsList(contentDocIdList);
        
        for(ContentVersion fileObj : fileList){
            String fileType 	= (fileObj.PathOnClient).remove(fileObj.Title + '.');
            String fileSize 	= Utility.convertFromByte(fileObj.ContentSize);
            FileDetailsWrapper wrapObj 	= new FileDetailsWrapper(false, fileObj.ContentDocumentId,fileObj.Title, fileType, contentDocMap.get(fileObj.ContentDocumentId).CreatedDate, contentDocMap.get(fileObj.ContentDocumentId).Owner.Name);
            wrapObj.fileSize	= fileSize;
            fileDetWrapList.add(wrapObj);
        }
        return fileDetWrapList;
    }
    
    
    /*
     *  Purpose : To delete File.
     */
    public static List<FileDetailsWrapper> deleteDocFile(String contractId, String documentId){
        ContentDocument contentObj  = new ContentDocument(Id = documentId);
        delete contentObj;
        try{
            List<Reference_Documents__c> refDocList     = [Select Id from Reference_Documents__c where Contract__c =: contractId AND File_URL__c =: documentId];
            delete refDocList;
        }catch(Exception e){
            system.debug('Exception::::'+e);
        }
        return getAllContractFiles(contractId);
    }
    
    
    /*
     * Purpose : To create Reference Doc records for uploaded files in Contract.
     */
    public static void createRefDocList(List<String> fileIds, List<String> fileName, String contractId){
        List<Reference_Documents__c> refDocInsertList 		= new List<Reference_Documents__c>();
        for(Integer i = 0; i < fileIds.size(); i++){
            Reference_Documents__c refDocObj 		= new Reference_Documents__c();
                refDocObj.Contract__c				= contractId;
                refDocObj.File_Name__c				= fileName[i];
                refDocObj.File_URL__c				= fileIds[i];
                refDocInsertList.add(refDocObj);
        }
        if(!refDocInsertList.isEmpty()) insert refDocInsertList;
    }
    
    
    /*
     * Purpose : To copy Files from Opportunity to Contract.
     */
    public static String copyFilesToContract(String req, String contractId){
        List<FileDetailsWrapper> fileDetailsWrapList	= (List<FileDetailsWrapper>) System.JSON.deserialize(req, List<FileDetailsWrapper>.class);
        List<Reference_Documents__c> refDocList 		= new List<Reference_Documents__c>();
        Map<String, Reference_Documents__c> refDocMap 	= new Map<String, Reference_Documents__c>();
        Set<String> contentDocumentIdSet 				= new Set<String>();
        try{
            refDocList									= FileUploadCtrlModel.getReferenceDocForContract(contractId);
            for(Reference_Documents__c refDocObj : refDocList){
                if(String.isNotBlank(refDocObj.File_URL__c)) {
                    contentDocumentIdSet.add(refDocObj.File_URL__c);
                    refDocMap.put(refDocObj.File_URL__c, refDocObj);
                }
            }
        }catch(DmlException e){}
         catch(Exception e){}
        return parseFilesAndInsertDelete(fileDetailsWrapList, contractId, contentDocumentIdSet, refDocList, refDocMap);
    }
    
    
    /*
    * Purpose : Insert new Reference Document records which are newly selected, and delete Reference document which are unselected.
    */
    static String parseFilesAndInsertDelete(List<FileDetailsWrapper> fileDetailsWrapList,String contractId, Set<String> contentDocumentIdSet, List<Reference_Documents__c> refDocList, Map<String, Reference_Documents__c> refDocMap){
        List<Reference_Documents__c> refDocInsertList 		= new List<Reference_Documents__c>();
        List<Reference_Documents__c> refDocDeleteList 		= new List<Reference_Documents__c>();
        for(FileDetailsWrapper filesWrapObj : fileDetailsWrapList){
            if(contentDocumentIdSet.isEmpty() && filesWrapObj.isSelected){
                Reference_Documents__c refDocObj 	= new Reference_Documents__c();
                refDocObj.Contract__c				= contractId;
                refDocObj.File_Name__c				= filesWrapObj.fileName;
                refDocObj.File_URL__c				= filesWrapObj.fileId;
                refDocInsertList.add(refDocObj);
            }
            else if(!contentDocumentIdSet.contains(filesWrapObj.fileId) && filesWrapObj.isSelected){
                Reference_Documents__c refDocObj 	= new Reference_Documents__c();
                refDocObj.Contract__c				= contractId;
                refDocObj.File_Name__c				= filesWrapObj.fileName;
                refDocObj.File_URL__c				= filesWrapObj.fileId;
                refDocInsertList.add(refDocObj);
            }else{
                if(!filesWrapObj.isSelected){
                    if(refDocMap.get(filesWrapObj.fileId) != null)
                        refDocDeleteList.add(refDocMap.get(filesWrapObj.fileId));
                }
            }
        }
        if(!refDocInsertList.isEmpty()) insert refDocInsertList;
        if(!refDocDeleteList.isEmpty()) delete refDocDeleteList;
        return 'SUCCESS';
    }
}