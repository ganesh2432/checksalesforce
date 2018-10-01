public class SendFileToZycusCtrlModel {
	
	public static ContentVersion getFileDetails(String fileId){
		return [Select Id, VersionData, PathOnClient, FileExtension, ContentDocumentId 
				from ContentVersion
				where Id =: fileId];
	}
}