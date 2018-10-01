public class FieldsForObjectRespWrapper {

    @AuraEnabled
    public String fieldName;
    @AuraEnabled
    public String fieldLabel;
    @AuraEnabled
    public String fieldType;
    
    public FieldsForObjectRespWrapper(String fieldName, String fieldLabel, String fieldType){
        this.fieldName 	= fieldName;
        this.fieldLabel = fieldLabel;
        this.fieldType 	= fieldType;
    }    
}