public class OpportunityTriggerService {

    public static void updateContractFields(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        List<Contract> contractList 								= new List<Contract>();
        Map<Id,List<Contract>> oppAndContractMap 					= new Map<Id,List<Contract>>();
        List<IContract_MetaData__c> metadataList 					= new List<IContract_MetaData__c>();
        Map<String,List<IContract_MetaData__c>> metadataAndTypeMap 	= new Map<String,List<IContract_MetaData__c>>();
        contractList												= OpportunityTriggerModel.getRelatedContractsOfOpp(newMap.KeySet());
        if(!contractList.isEmpty()){
            oppAndContractMap	=	prepareOppAndContractMap(contractList, oppAndContractMap);
            metadataList		=   OpportunityTriggerModel.getAllIContractMetadata();
            metadataAndTypeMap	= 	prepareMetadataAndTypeMap(metadataList, metadataAndTypeMap);
            try{
                traverseContractsAndUpdate(newMap, oldMap, oppAndContractMap, metadataAndTypeMap);
            }catch(Exception e){
                HandleBusinessException.captureError('OpportunityTriggerService', 'traverseContractsAndUpdate', e);
            }
        }
    }
    
    
    static Map<Id,List<Contract>> prepareOppAndContractMap(List<Contract> contractList, Map<Id,List<Contract>> oppAndContractMap){
        for(Contract contractObj : contractList){
            if(oppAndContractMap.containsKey(contractObj.Opportunity__c))
                oppAndContractMap.get(contractObj.Opportunity__c).add(contractObj);
            else
                oppAndContractMap.put(contractObj.Opportunity__c, new List<Contract> {contractObj});
        }
        return oppAndContractMap;
    }
    
    
    static Map<String,List<IContract_MetaData__c>> prepareMetadataAndTypeMap(List<IContract_MetaData__c> metadataList, Map<String,List<IContract_MetaData__c>> metadataAndTypeMap){
        for(IContract_MetaData__c metadata : metadataList){
            if(metadataAndTypeMap.containsKey(metadata.Mapping_Configurations__r.Type__c + metadata.Mapping_Configurations__r.SubType__c))
                metadataAndTypeMap.get(metadata.Mapping_Configurations__r.Type__c + metadata.Mapping_Configurations__r.SubType__c).add(metadata);
            else
                metadataAndTypeMap.put(metadata.Mapping_Configurations__r.Type__c + metadata.Mapping_Configurations__r.SubType__c, new List<IContract_MetaData__c> {metadata});
        }
        return metadataAndTypeMap;
    }
    
    
    static void traverseContractsAndUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap, Map<Id,List<Contract>> oppAndContractMap, Map<String,List<IContract_MetaData__c>> metadataAndTypeMap){
        List<Contract> contractsToUpdateList 	= new List<Contract>();
        for(String opportunityId : newMap.keySet()){
            if(oppAndContractMap.containsKey(opportunityId)){
                for(Contract contractObj : oppAndContractMap.get(opportunityId)){
                    Boolean isChanged	= false;
                    if(metadataAndTypeMap.containsKey(contractObj.Type__c + contractObj.SubType__c)){
                        for(IContract_MetaData__c metaDataObj : metadataAndTypeMap.get(contractObj.Type__c + contractObj.SubType__c)){
                            if(newMap.get(opportunityId).get(metaDataObj.Mapping_Field_2__c) != oldMap.get(opportunityId).get(metaDataObj.Mapping_Field_2__c)){
								contractObj.put(metaDataObj.Mapping_Field__c, newMap.get(opportunityId).get(metaDataObj.Mapping_Field_2__c));                 
                                if(String.isNotBlank(contractObj.IContract_Id__c)) contractObj.Update_from_Opportunity__c = true;
                                isChanged 	= true; 
                            }
                        }
                    }
                    if(isChanged) contractsToUpdateList.add(contractObj);
                }
            }
        }
        if(!contractsToUpdateList.isEmpty()){
            try{
                update contractsToUpdateList;
            }catch(Exception e){
                HandleBusinessException.captureError('OpportunityTriggerService', 'traverseContractsAndUpdate', e);
            }
        }
    }
}