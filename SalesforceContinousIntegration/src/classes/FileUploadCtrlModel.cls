/*
* @Author               : Rahul Sangwan
* Created By            : Rahul Sangwan (19/07/2018)
* Last Modified By      : Rahul Sangwan (11/09/2018)
* @Description          : Model class for FileUploadCtrl.
*/
public class FileUploadCtrlModel {
    
    public static Id getOpportunityIdFromContract(String contractId){
        return [Select Id, Opportunity__c from Contract where Id =: contractId].Opportunity__c;
    }
    
    
    public static List<ContentDocumentLink> getContentDocListFromParentId(String parentId){
        return [Select Id, ContentDocumentId, LinkedEntityId
                from ContentDocumentLink
                where LinkedEntityId =: parentId];
    }
    
    
    public static Map<Id, ContentDocument> getContentDocDetailsList(List<String> contentDocIdList){
        return new Map<Id, ContentDocument>([Select Id, Owner.Name, CreatedDate 
											 from ContentDocument
											 where Id IN: contentDocIdList]);
    }
    
    
    public static List<ContentVersion> getFileDetailsList(List<String> contentDocIdList){
        return [Select Id, ContentLocation, PathOnClient, Origin, Title, ContentDocumentId, ContentSize 
                from ContentVersion 
                where ContentDocumentId IN: contentDocIdList ORDER BY CreatedDate Desc];
    }
    
    
    public static List<Reference_Documents__c> getReferenceDocForContract(String contractId){
        return [Select Id, Contract__c, File_URL__c
                from Reference_Documents__c 
                where Contract__c =: contractId];
    }
    
    
    public static Contract getContractDetails(String contractId){
        return [Select Id, Template_DocumentId__c 
                from Contract 
                where Id =: contractId];
    }

}