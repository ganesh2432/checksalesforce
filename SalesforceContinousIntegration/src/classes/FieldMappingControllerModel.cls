/*
* @Author             : Rahul Sangwan
* Created By          : Rahul Sangwan (30/04/2018)
* Last Modified By    : Rahul Sangwan (31/05/2018)
* @Description        : Model class for FieldMappingController.
*/
public with sharing class FieldMappingControllerModel {

    public static List<Mapping_Configurations__c> getContractMappingConfig(){
        return [Select Id, Type__c, SubType__c, Status__c, CreatedBy.Name, LastModifiedDate,
                Last_Updated_On_Custom__c, Created_By_Custom__r.Name, Stage__c,
                (Select Id from IContract_Fields_Metadata__r) 
                from Mapping_Configurations__c
                ORDER BY Status__c ASC];
    }
    
    
    public static Mapping_Configurations__c getContractMappingConfigRec(String selType, String selSubType){
        return [Select Id, Type__c, SubType__c, Status__c, CreatedBy.Name, LastModifiedDate, Created_By_Custom__r.Name, Stage__c 
                from Mapping_Configurations__c
                where Type__c =: selType AND SubType__c =: selSubType
                LIMIT 1];
    }
    
    
    public static Mapping_Configurations__c getContractMappingConfigRecFromId(String mapConfigId){
        return [Select Id, Status__c,Last_Updated_On_Custom__c, Created_By_Custom__r.Name
                from Mapping_Configurations__c
                where Id =: mapConfigId
               ];
    }
        
    
    public static List<IContract_MetaData__c> getMetadataRecList(String selType, String selSubType){
        return [Select Id, Field_Name__c,  Mapping_Configurations__c, Mapping_Configurations__r.Type__c, Mapping_Configurations__r.SubType__c, Active__c
                from IContract_MetaData__c
                where Mapping_Configurations__r.Type__c =: selType 
                AND Mapping_Configurations__r.SubType__c =: selSubType
                AND Active__c = true
                ];
    }
    
    
    public static List<IContract_MetaData__c> getMetadataRecList(String mapConfigId){
        return [Select Id, Field_Name__c,  Mapping_Configurations__c, Mapping_Configurations__r.Type__c, Mapping_Configurations__r.SubType__c
                from IContract_MetaData__c
                where Mapping_Configurations__c =: mapConfigId
                ];
    }
    
    
}