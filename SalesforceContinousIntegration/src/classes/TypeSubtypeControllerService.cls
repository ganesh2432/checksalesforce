/*
* @Author               : Rahul Sangwan
* Created By            : Rahul Sangwan (30/04/2018)
* Last Modified By      : Rahul Sangwan (31/05/2018)
* @Description          : Service class for IContractTypeSubTypeComponent
*/
public with sharing class TypeSubtypeControllerService {

    
    //Purpose : Get all Active Mapping configuration from the system,
    //          and return Map of Type and List of Subtype as values.
    public static Map<String, List<String>> prepareTypeAndSubTypeMap(){
        Map<String, List<String>> typeSubTypeMap 				= new Map<String, List<String>>();
        List<Mapping_Configurations__c> activeTypeSubTypeList 	= new List<Mapping_Configurations__c>();
        try{
            activeTypeSubTypeList 	=  TypeSubtypeControllerModel.getTypeSubTypeFromMappingConfig();
            if(!activeTypeSubTypeList.isEmpty()){
                //Prepare Map of Type and Subtype.
                typeSubTypeMap	= prepareTypeSubTypeMapFromMapConfigList(activeTypeSubTypeList, typeSubTypeMap);
            }
        }catch(Exception e){
            HandleBusinessException.captureError('TypeSubtypeControllerService', 'prepareTypeAndSubTypeMap', e);
        }
        return typeSubTypeMap;
    }
    
    
    static Map<String, List<String>> prepareTypeSubTypeMapFromMapConfigList(List<Mapping_Configurations__c> activeTypeSubTypeList, Map<String, List<String>> typeSubTypeMap){
        for(Mapping_Configurations__c mapConfigObj : activeTypeSubTypeList){
            if(typeSubTypeMap.containsKey(mapConfigObj.Type__c)){
                typeSubTypeMap.get(mapConfigObj.Type__c).add(mapConfigObj.SubType__c);
            }else{
                typeSubTypeMap.put(mapConfigObj.Type__c, new List<String>{mapConfigObj.SubType__c});
            }
        }
        return typeSubTypeMap;
    }
}