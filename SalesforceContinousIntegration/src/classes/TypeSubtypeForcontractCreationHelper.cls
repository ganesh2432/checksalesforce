/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public class TypeSubtypeForcontractCreationHelper {
    
    
    //Purpose : Get all Active Mapping configuration from the system,
    //          and return Map of Type and List of Subtype as values.
    public static String prepareTypeAndSubTypeMap(String OppId){
        Map<String, List<String>> typeSubTypeMap                = new Map<String, List<String>>();
        enableDisableWrp enbDsblWrp = new enableDisableWrp();
        List<Mapping_Configurations__c> activeTypeSubTypeList   = new List<Mapping_Configurations__c>();
        try{
            activeTypeSubTypeList   =  TypeSubtypeControllerModel.getTypeSubTypeFromMappingConfig();
            if(!activeTypeSubTypeList.isEmpty()){
                //Prepare Map of Type and Subtype.
                enbDsblWrp  = prepareTypeSubTypeMapFromMapConfigList(activeTypeSubTypeList, typeSubTypeMap,OppId);
            }
        }catch(Exception e){
            HandleBusinessException.captureError('TypeSubtypeForcontractCreationHelper', 'prepareTypeAndSubTypeMap', e);
        }
        return json.serialize(enbDsblWrp);
    }
    
    //Preparing Map of type and subtype values which enabling and disabling type and subtypes based on opportunity stage and admin opp stage selection
    static enableDisableWrp prepareTypeSubTypeMapFromMapConfigList(List<Mapping_Configurations__c> activeTypeSubTypeList, Map<String, List<String>> typeSubTypeMap,String OppId){
        try{
        Opportunity opp  = [Select id,StageName,Probability From Opportunity where id=:OppId];
        List<OpportunityStage> oppStages = [Select id,ApiName,DefaultProbability From OpportunityStage];   
        
        Map<String,Decimal> oppStgesWithProbabilityVal = new Map<String,Decimal>();
        for(OpportunityStage oppStg : oppStages){
            oppStgesWithProbabilityVal.put(oppStg.ApiName,oppStg.DefaultProbability);
        }
        
        Set<String> enabledAndDisableCheck = new Set<String>();
            //map is being created based for which type and subtype should be enabled and disabled
        for(Mapping_Configurations__c mapConfigObj : activeTypeSubTypeList){
             if(typeSubTypeMap.containsKey(mapConfigObj.Type__c)){
                    typeSubTypeMap.get(mapConfigObj.Type__c).add(mapConfigObj.SubType__c);
                }else{
                    typeSubTypeMap.put(mapConfigObj.Type__c, new List<String>{mapConfigObj.SubType__c});
                } 
            
            if(oppStgesWithProbabilityVal.get(opp.StageName)>=oppStgesWithProbabilityVal.get(mapConfigObj.Allow_Stage__c) && mapConfigObj.Status__c=='Active'){
  
                if(!enabledAndDisableCheck.contains(mapConfigObj.Type__c+'@@'+mapConfigObj.SubType__c+'@@Enabled')){
                    enabledAndDisableCheck.add(mapConfigObj.Type__c+'@@'+mapConfigObj.SubType__c+'@@Enabled');
                }
                
            }else{
               
                if(!enabledAndDisableCheck.contains(mapConfigObj.Type__c+'@@'+mapConfigObj.SubType__c+'@@Disabled')){
                    enabledAndDisableCheck.add(mapConfigObj.Type__c+'@@'+mapConfigObj.SubType__c+'@@Disabled');
                }
            }
        }
        enableDisableWrp enbDsbWrp = new enableDisableWrp();
        enbDsbWrp.enabledAndDisable = enabledAndDisableCheck;
        enbDsbWrp.typeSbTypeMap = typeSubTypeMap;
        return enbDsbWrp;
        }Catch(Exception e){
            HandleBusinessException.captureError('TypeSubtypeForcontractCreationHelper', 'prepareTypeSubTypeMapFromMapConfigList', e);
            return null;
        }
    }
    
    //wrapper to hold enabled and disabled type and dependent subtype list
    public class enableDisableWrp{
        public Set<String> enabledAndDisable;
        public Map<String, List<String>> typeSbTypeMap;
        
        public enableDisableWrp(){
           enabledAndDisable = new Set<String>();
           typeSbTypeMap = new Map<String, List<String>>();
        }
    }
}