/*----------------------------------------------------------------------------
* Description :   This controller is used for Contract request wizard
* Created By  :   Jayanth B
* Created Date:   02/06/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class RequestWizardController {
    
    //to save the request contract metatada																																																																																																																																																																																																																					`																																																																																																												
    @AuraEnabled
    public static void SaveRequestWizard(List<Request_Wizard_MetaData__c> reqWizardList){
          RequestWizardHelper.SaveRequestWizard(reqWizardList);
    }
    
    //to get existing request contract metatada
    @AuraEnabled
    public static List<Request_Wizard_MetaData__c > getRequestWizardsMetadata(String selectedType,String selectedSubType){
        return RequestWizardHelper.getRequestWizardsMetadata(selectedType,selectedSubType,true);
    }

}