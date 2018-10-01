public with sharing class DocumentSetupWrapper{
    public String types;	//PROCUREMENT
    public String subType;	//PURCHASEORDER
    public String allowedStage;	//Value Proposition
    public boolean storeFiles;
    public boolean allowLineItem;
    
    public static DocumentSetupWrapper parse(String json){
        return (DocumentSetupWrapper) System.JSON.deserialize(json, DocumentSetupWrapper.class);
    }
}