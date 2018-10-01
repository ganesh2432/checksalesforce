public class TemplateFileDetailsWrapper {
    @AuraEnabled
    public String opportuniytIds {get ; set;}
    @AuraEnabled
    public String templatenames {get ; set;}
    @AuraEnabled
    public String isstndrdtemplts {get ; set;}
    @AuraEnabled
    public String templstedocids {get ; set;}
    @AuraEnabled
    public String templateIdfileSize {get ; set;}
      
      public TemplateFileDetailsWrapper(){
          opportuniytIds = '';
          templatenames ='';
          isstndrdtemplts = '';
          templstedocids ='';
          templateIdfileSize='';
      }
  }