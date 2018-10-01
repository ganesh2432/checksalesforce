public class IContractMetaDataTriggerHelperService {

    public static void updateMappingConfigFields(Map<Id, IContract_MetaData__c> newMap, Map<Id, IContract_MetaData__c> oldMap){
        Set<String> mappingConfigIdSet 	= new Set<String>();
        for(IContract_MetaData__c metaDataObj : newMap.values()){
            if(String.isNotBlank(metaDataObj.Mapping_Configurations__c)){
                mappingConfigIdSet.add(metaDataObj.Mapping_Configurations__c);
            } 	  
        }
        
        if(!mappingConfigIdSet.isEmpty()){
            updateMappingConfigRec(mappingConfigIdSet);
        }
    }
    
    
    static void updateMappingConfigRec(Set<String> mappingConfigIdSet){
  		List<Mapping_Configurations__c> mappingConfigList 	= new List<Mapping_Configurations__c>();
        mappingConfigList 									= IContractMetaDataTriggerHelperModel.getMappingConfigDetail(mappingConfigIdSet);
        for(Mapping_Configurations__c configObj :mappingConfigList){
            configObj.Last_Updated_On_Custom__c 	= System.now();
        }
        try{
            update mappingConfigList;
        }catch(Exception e){
            
        }
    }


    public static void updateMappingConfigFieldsAfterInsert(List<IContract_MetaData__c> newList){
        Set<String> mappingConfigIdSet  = new Set<String>();
        for(IContract_MetaData__c metaDataObj : newList){
            if(String.isNotBlank(metaDataObj.Mapping_Configurations__c)){
                mappingConfigIdSet.add(metaDataObj.Mapping_Configurations__c);
            }     
        }
        
        if(!mappingConfigIdSet.isEmpty()){
            updateMappingConfigRecAftInsert(mappingConfigIdSet);
        }
    }


    static void updateMappingConfigRecAftInsert(Set<String> mappingConfigIdSet){
        List<Mapping_Configurations__c> mappingConfigList   = new List<Mapping_Configurations__c>();
        try{
            mappingConfigList                                   = IContractMetaDataTriggerHelperModel.getMappingConfigDetailWithoutCreatedBy(mappingConfigIdSet);
            for(Mapping_Configurations__c configObj :   mappingConfigList){
                configObj.Created_By_Custom__c          = UserInfo.getUserId();
                configObj.Last_Updated_On_Custom__c     = System.now();
            }
            try{
                update mappingConfigList;
                }catch(Exception e){
            }
        }catch(Exception e){}
    }


    public static void updateMappingConfigFieldsAfterDelete(List<IContract_MetaData__c> oldList){
        Set<String> mappingConfigIdSet  = new Set<String>();
        for(IContract_MetaData__c metaDataObj : oldList){
            if(String.isNotBlank(metaDataObj.Mapping_Configurations__c)){
                mappingConfigIdSet.add(metaDataObj.Mapping_Configurations__c);
            }     
        }
        
        if(!mappingConfigIdSet.isEmpty()){
            updateMappingConfigRecAftDelete(mappingConfigIdSet, oldList);
        }
    }


    static void updateMappingConfigRecAftDelete(Set<String> mappingConfigIdSet, List<IContract_MetaData__c> oldList){
        List<Mapping_Configurations__c> mappingConfigList            = new List<Mapping_Configurations__c>();
        List<Mapping_Configurations__c> mappingConfigListtoUpdate    = new List<Mapping_Configurations__c>();
        try{
            mappingConfigList                           = IContractMetaDataTriggerHelperModel.getMappingConfigDetailWithChildRec(mappingConfigIdSet, oldList);
            for(Mapping_Configurations__c configObj :   mappingConfigList){
               if(configObj.IContract_Fields_Metadata__r.isEmpty()){                    
                    configObj.Created_By_Custom__c          = null;
                    configObj.Last_Updated_On_Custom__c     = null;
                }
            }
            try{
                update mappingConfigList;
                }catch(Exception e){
            }
        }catch(Exception e){}
    }
}