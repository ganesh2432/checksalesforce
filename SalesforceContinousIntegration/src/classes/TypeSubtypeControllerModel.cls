/*
* @Author               : Rahul Sangwan
* Created By            : Rahul Sangwan (30/04/2018)
* Last Modified By      : Rahul Sangwan (31/05/2018)
* @Description          : Model class for IContractTypeSubTypeComponent
*/
public with sharing class TypeSubtypeControllerModel {

    public static List<Mapping_Configurations__c> getTypeSubTypeFromMappingConfig(){
        return [Select Id, Type__c, SubType__c, Active__c,Status__c,Allow_Stage__c   
                from Mapping_Configurations__c
                where Active__c = true
                ORDER BY Type__c ASC];
    }
}