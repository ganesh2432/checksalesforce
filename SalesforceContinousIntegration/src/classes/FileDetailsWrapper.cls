public class FileDetailsWrapper {

    @AuraEnabled
    public Boolean isSelected {get ; set;}
    @AuraEnabled
    public String fileId {get ; set;}
    @AuraEnabled
    public String fileName {get ; set;}
    @AuraEnabled
    public String fileType {get ; set;}
    @AuraEnabled
    public DateTime createdOn {get ; set;}
    @AuraEnabled
    public String createdBy {get ; set;}
    @AuraEnabled
    public String fileSize {get ; set;}
    
    public FileDetailsWrapper(Boolean isSelected, String fileId, String fileName, String fileType, DateTime createdOn, String createdBy){
        this.isSelected 	= isSelected;
        this.fileId 		= fileId;
        this.fileName 		= fileName;
        this.fileType		= fileType;
        this.createdOn		= createdOn;
        this.createdBy		= createdBy;
    }
}