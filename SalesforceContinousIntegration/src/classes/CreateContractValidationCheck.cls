/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class CreateContractValidationCheck {
    
    //Checks whether the opportunity is allowed for contract creation through opportunity stage field which was setup in admin config
    @AuraEnabled
    public static boolean isAllowedToCreateContract(String OppId) {
        Opportunity opp  = [Select id,StageName,Probability From Opportunity where id=:OppId];
        
        List<Mapping_Configurations__c> mappingConfigList = [Select id,Allow_Stage__c from Mapping_Configurations__c where Active__c = true and Allow_Stage__c!=null and Status__c=:Constants.Mappingcong_status];
        
        Set<String> availableStages = new Set<String>();
        for(Mapping_Configurations__c mppgconf : mappingConfigList){
            availableStages.add(mppgconf.Allow_Stage__c);
        }
        
        List<OpportunityStage> oppStages = [Select id,ApiName,DefaultProbability From OpportunityStage];   
        
        Map<String,Decimal> oppStgesWithProbabilityVal = new Map<String,Decimal>();
        for(OpportunityStage oppStg : oppStages){
            oppStgesWithProbabilityVal.put(oppStg.ApiName,oppStg.DefaultProbability);
        }
        
        List<Decimal> minAvialbleProb = new List<Decimal>();
        for(String s :availableStages){
            minAvialbleProb.add(oppStgesWithProbabilityVal.get(s));
        }
        
        
        
        minAvialbleProb.sort();
        Decimal MinValue = minAvialbleProb[0];
        
        //If specific Opportunity satisfy the basic validation which was setup in Admin config then true is returned or else false is written
        if(oppStgesWithProbabilityVal.get(opp.StageName) >= MinValue){
            
            return true;
        }else{
            return false;
        }
        
    }
    
}