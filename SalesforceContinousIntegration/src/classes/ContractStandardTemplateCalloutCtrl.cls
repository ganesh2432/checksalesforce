/*----------------------------------------------------------------------------
* Description :   This class is used to get standard template details from zycus 
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractStandardTemplateCalloutCtrl {

    public static ContractStandardTemplateCalloutHelper.Response getStandardTemplateDetails(){
        return ContractStandardTemplateCalloutHelper.getStandardTemplateDetails();
    }
}