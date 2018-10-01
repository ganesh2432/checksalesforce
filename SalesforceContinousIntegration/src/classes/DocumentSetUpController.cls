/*----------------------------------------------------------------------------
* Description :   This controller is used for doc setup
* Created By  :   Jayanth B
* Created Date:   02/06/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class DocumentSetUpController {
    //to get the picklist value of specified object annd field
    @AuraEnabled
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
      return DocumentSetUpHelper.getPicklistValues(ObjectApi_name,Field_name);   
    }
    
    @AuraEnabled // to get existing mapping config for specified type and subtype
    public static Mapping_Configurations__c getMppingConfigForTypeAndSubType(String typeName,String subType){
       return DocumentSetUpHelper.getMppingConfigForTypeAndSubType(typeName,subType);
    }
    
    @AuraEnabled // upsert of mapping configuration sent through DocumentSetupWrapper with allowed stages,store fiels and allow fiels values
    public static void createMappingConfigurations(String documentSetupWrpAsString){
        DocumentSetUpHelper.createMappingConfigurations(documentSetupWrpAsString);
    }
    
    @AuraEnabled //to activate the mapping config
    public static void activateMappingConfigurations(String activateMappngConfigAsString){
        DocumentSetUpHelper.activateMappingConfigurations(activateMappngConfigAsString);
    }
    
}