/*----------------------------------------------------------------------------
* Description :   This class is used to get basic details of contract
* Created By  :   Jayanth B
* Created Date:   03/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class EditContractcontroller {

    @AuraEnabled
    public static Contract getTypeandSubType(String contrctId){
        Contract contrct = [Select id,Type__c,IContract_Status__c,Contract_Number__c,SubType__c,Is_RequestWizard_Contract__c,Opportunity__c,IsStandardTemplate__c,Template_DocumentId__c,Template_Name__c from contract where id=:contrctId];
        return contrct;
    }
}