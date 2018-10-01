/*
* @Author             : Rahul Sangwan
* Created By          : Rahul Sangwan (30/04/2018)
* Last Modified By    : Rahul Sangwan (31/05/2018)
* @Description        : Controller for IContractStoredMappings, FieldMapping and
*                       FieldSelection Component. 
*/
public with sharing class FieldMappingController {

    
    //Purpose : Method to hit IContract Metadata API to get fields available for selection
    //          and send result to front end.    
    @AuraEnabled
    public static FetchMetadataAPICtrl.Response service() {
        return FetchMetadataAPICtrl.getFieldMetadataCallout();
    }

    
    //Purpose : To get fields already selected for particular Type and Subtype.
    @AuraEnabled
    public static List<String> getExistingSelFieldRecords(String selType, String selSubType){
        return FieldMappingControllerService.getExistingSelFieldRecords(selType, selSubType);
    }
    
    
    //Purpose : To get existing Mapping configurations record in the system,
    //          for which there is atleast 1 IContract Fields Metadata record.
    @AuraEnabled
    public static List<Mapping_Configurations__c> getContractMappingRecords(){
        return FieldMappingControllerService.getContractMappingRecords();
    }
    
    
    //Purpose : To upsert the selected fields for Type and Subtype, and inactive the IContract
    //          Metadata records, which were previously selected but unselected in current request.
    @AuraEnabled
    public static String createFieldsMetadata(String selType, String selSubType, String fieldSelectedData){
        fieldSelectedData = '{"selFields":' + fieldSelectedData + '}';
        FieldSelectionRespWrapper fieldWrap 	= FieldSelectionRespWrapper.parse(fieldSelectedData);
        return FieldMappingControllerService.createFieldsMetadata(selType, selSubType, fieldWrap);
    }
    
    
    //Purpose : To Activate the Contract(Mapping Configuration record).
    @AuraEnabled
    public static String activateContract(String contractId){
		return FieldMappingControllerService.activateContract(contractId);        
    }


    //Purpose : To Dectivate the Contract(Mapping Configuration record).
    @AuraEnabled
    public static String deactivateContract(String contractId){
        return FieldMappingControllerService.deactivateContract(contractId);        
    }
    
    
    //Purpose : To Delete the Contract(Mapping Configuration record).
    @AuraEnabled
    public static String deleteContract(String contractId){
		return FieldMappingControllerService.deleteContract(contractId);        
    }
    
    
    //Purpose : To Copy the Contract(Mapping Configuration record), into new Contract with
    //          different Type and Subtype(with all of its child records).
    @AuraEnabled
    public static String copyContract(String contractId, String selType, String selSubType){
        Savepoint sp = Database.setSavepoint();
        String res;
        try{
            res   = FieldMappingControllerService.copyContract(contractId, selType, selSubType);    
        }catch(Exception e){
            return e.getMessage();
        }
        
        if(!res.equals(System.Label.Success_return_message)){
            Database.rollback(sp);
        }
        return res;
    }
    
}