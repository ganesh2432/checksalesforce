public class IContractMetaDataTriggerHelper {
// as of now not being used    
/*
    public static void onAfterUpdate(Map<id,IContract_MetaData__c> oldMap , Map<id,IContract_MetaData__c> newMap){
        Set<String> FieldChangedIcontractId = new Set<String>();
        for(IContract_MetaData__c iContractMtd : newMap.values()){   
            if(oldMap.get(iContractMtd.id).Mapping_Field__c != newMap.get(iContractMtd.id).Mapping_Field__c ){
                FieldChangedIcontractId.add(iContractMtd.id);
            }
        }
        
        if(!FieldChangedIcontractId.isEmpty()){
            List<Value_Mapping__c> toEraseMappedValueAndField =  [select id,Field_Name__c,Mapping_Object__c,Mapping_Field__c,IContract_Field_Metadata__c,IContract_Field_Metadata__r.Mapping_Field__c,IContract_Value__c,Mapping_Value__c from Value_Mapping__c where IContract_Field_Metadata__c=:FieldChangedIcontractId];
            for(Value_Mapping__c valMppng : toEraseMappedValueAndField){
                valMppng.Mapping_Field__c = valMppng.IContract_Field_Metadata__r.Mapping_Field__c;
                valMppng.Mapping_Value__c = '';
            }
            update toEraseMappedValueAndField;
        }
    }*/
    
    public static void onAfterUpdate(Map<Id, IContract_MetaData__c> newMap, Map<Id, IContract_MetaData__c> oldMap){
        IContractMetaDataTriggerHelperService.updateMappingConfigFields(newMap, oldMap);
    }


    public static void onAfterInsert(List<IContract_MetaData__c> newList){
        IContractMetaDataTriggerHelperService.updateMappingConfigFieldsAfterInsert(newList);
    }


    public static void onAfterDelete(List<IContract_MetaData__c> oldList){
        IContractMetaDataTriggerHelperService.updateMappingConfigFieldsAfterDelete(oldList);
    }
}