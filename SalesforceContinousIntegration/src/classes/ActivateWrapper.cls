public with sharing class ActivateWrapper {
    public String types;	//PROCUREMENT
    public String subType;	//PURCHASEORDER
    public String activateMappingconfig;
    
    public static ActivateWrapper parse(String json){
        return (ActivateWrapper) System.JSON.deserialize(json, ActivateWrapper.class);
    }
}