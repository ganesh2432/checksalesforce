/*----------------------------------------------------------------------------
* Description :   This class is used as basic helper to check line item aloowed or not and to delete contract
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public class LightningCreateContractPrgsIndtr {
    
    @AuraEnabled
    public static String redirect(String oppId) {
        // page reference wont work 
        PageReference nextPage = new PageReference('/' + oppId);
        system.debug(nextPage);
        return String.valueOf(nextPage);
    }
    
    //Used to know whether for particular type and subtype line item question
    // should be enabled or not while contract creation
    @AuraEnabled
    public static String isLineItemAllowed(String selectedType,String selectedSubType){
        try{
            Mapping_Configurations__c mppngConfig = [Select id,Allow_LineItems__c from Mapping_Configurations__c where Type__c=:selectedType and SubType__c=:selectedSubType LIMIT 1];
            return String.valueOf(mppngConfig.Allow_LineItems__c);
        }catch(Exception e){
            return 'Exception';
        }
    }
    
    //Delete the contract on click of discard
    @AuraEnabled
    public static String deleteContract(String contrctId){
        try{
            List<Reference_Documents__c> refDoc = [Select id,Is_Template_Doc__c from Reference_Documents__c where Contract__c=:contrctId];
            if(refDoc.size()>0){
                delete refDoc;
            }
            
            delete [Select id from Contract where id=:contrctId];
            
            return 'Success';
        }Catch(Exception e){
            return 'Exception';
        }
    }
}