/*----------------------------------------------------------------------------
* Description :   This class is used to fetch CP data from zycus endpoint
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractPartyDataFetch {

    // used to get contract party details by making HTTP callout to zycus endpoint
     @AuraEnabled
    public static ContractPartyAPICallout.Response getContractPartyData(String contracType,String searchText, Integer currentPage,boolean isOnload){
       try{
       return  ContractPartyAPICallout.getContractPartyData(contracType,searchText,currentPage,isOnload);
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractPartyDataFetch', 'getContractPartyData', e);return null;
        }
    } 
}