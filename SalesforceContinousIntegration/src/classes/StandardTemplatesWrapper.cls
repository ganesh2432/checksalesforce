public class StandardTemplatesWrapper {
    @AuraEnabled
    public String templateNumber {get ; set;}	//JB001
    @AuraEnabled
    public String templateTitle {get ; set;}	//Finance Template
    @AuraEnabled
    public String templateDescription {get ; set;}	//
    @AuraEnabled
    public String templateFor {get ; set;}	//Contract
    @AuraEnabled
    public String language {get ; set;}	//English
    
    public StandardTemplatesWrapper(){ 
        templateNumber = '';	//JB001
        templateTitle = '';	//Finance Template
        templateDescription = '';	//
        templateFor = '';	//Contract
        language = '';
    }
}