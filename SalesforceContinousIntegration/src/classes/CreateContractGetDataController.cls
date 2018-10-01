/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   09/10/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class CreateContractGetDataController{

    //used to get details to create contract from opportunity record by whos fields which are mapped in icontractmapping config
    @AuraEnabled
    public static String getContractDetails(String oppId,String selectedType,String selectedSubType){
        return CreateContractGetDataHelper.getContractDetails(oppId,selectedType,selectedSubType);
    }
    
    //used to create contract/update contract details sent from request wizard
    @AuraEnabled
    public static String createContractData(String contrctId,String oppId, String stageStr,String selectedType,String selectedSubType){
       return CreateContractGetDataHelper.createContractData(contrctId,oppId,stageStr,selectedType,selectedSubType);
    }
    
    //used to get details to edit contract from contract record by whos fields which are mapped in icontractmapping config
    @AuraEnabled
    public static String getEditContractDetails(String contrctid,String selectedType,String selectedSubType){
        return CreateContractGetDataHelper.getEditContractDetails(contrctid,selectedType,selectedSubType);
    }
    
    //used to get details of contract owner and contract party during Edit of contract through request wizard
    @AuraEnabled
    public static contract getcontractOwnerdata(String contrctid){
        return CreateContractGetDataHelper.getcontractOwnerdata(contrctid);
    }
    
}