/*----------------------------------------------------------------------------
* Description :   This class is used to fetch CO data from zycus endpoint
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractOwnerDataFetch {
    
    // used to get contract owner details by making HTTP callout to zycus endpoint
    @AuraEnabled
    public static ContractOwnerAPICallout.Response getContractOwnerData(String contracType, String searchBy, String searchText, Integer currentPage,boolean isOnload){
        
        try{
            return ContractOwnerAPICallout.getContractOwnerData(contracType,searchBy,searchText,currentPage,isOnload);
        }Catch(Exception e){
            system.debug(e.getMessage()+'::'+e.getStackTraceString()+'::'+e.getLineNumber());
            return null;
        }
    }
}