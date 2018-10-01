/*
* @Author             : Rahul Sangwan
* Created By          : Rahul Sangwan (30/04/2018)
* Last Modified By    : Rahul Sangwan (31/05/2018)
* @Description        : Service class for FieldMappingController.
*/
public with sharing class FieldMappingControllerService {
    
    
    //Purpose : Get all Existing Contract(Mapping Configurations). 
    //          All existing Mapping confguration will have child IContractFieldMetadata records.
    public static List<Mapping_Configurations__c> getContractMappingRecords(){
        List<Mapping_Configurations__c> contractMappingList 	= new List<Mapping_Configurations__c>();
        List<Mapping_Configurations__c> contRetMappingList 		= new List<Mapping_Configurations__c>();
        try{
            contractMappingList		= FieldMappingControllerModel.getContractMappingConfig();	
            for(Mapping_Configurations__c configObj :contractMappingList){
                if(!configObj.IContract_Fields_Metadata__r.isEmpty()){
                    contRetMappingList.add(configObj);
                }
            }
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'getContractMappingRecords', e);
        }
        return contRetMappingList;
    }
    
    
    //Purpose : Save selected fields in IContractMetadata Object for selected Mapping configuration.
    public static String createFieldsMetadata(String selType, String selSubType, FieldSelectionRespWrapper fieldWrap){
        Mapping_Configurations__c mapConfigObj 						= new Mapping_Configurations__c();
        List<IContract_MetaData__c> exisMetadataList 				= new List<IContract_MetaData__c>();
        Map<String, IContract_MetaData__c> fieldNameAndMetadataMap 	= new Map<String, IContract_MetaData__c>();
        try{
            mapConfigObj 								= FieldMappingControllerModel.getContractMappingConfigRec(selType, selSubType);
            try{
                exisMetadataList 						= FieldMappingControllerModel.getMetadataRecList(mapConfigObj.Id);
                for(IContract_MetaData__c metadatObj : exisMetadataList){
                    fieldNameAndMetadataMap.put(metadatObj.Field_Name__c , metadatObj);
                }
            }catch(Exception e){}
            List<IContract_MetaData__c> metadataList    = new List<IContract_MetaData__c>();
            //Create new IContract Metadata record for new fields selected,
            //and if already existing fields unselected, then make them inactive.
            metadataList								= createMetadataList(metadataList, mapConfigObj, fieldWrap, fieldNameAndMetadataMap);

            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.icontractMetadatafields();        
            SecurityUtils.checkInsert(IContract_MetaData__c.SObjectType,requestFieldsList);
            SecurityUtils.checkUpdate(IContract_MetaData__c.SObjectType,requestFieldsList);

            upsert metadataList;
            mapConfigObj.Stage__c   = Constants.STAGE1_MAP_CONFIG;
            update mapConfigObj;
            return mapConfigObj.Id;
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'createFieldsMetadata', e);
            system.debug('e::::::'+e.getMessage());
            return 'Exception: ' + e.getMessage();
        }
    }
    
    
    static List<IContract_MetaData__c> createMetadataList(List<IContract_MetaData__c> metadataList,
                                                          Mapping_Configurations__c mapConfigObj, 
                                                          FieldSelectionRespWrapper fieldWrap,
                                                          Map<String, IContract_MetaData__c> fieldNameAndMetadataMap){
        Set<String> fieldNameSet 					= new Set<String>();
        for(FieldSelectionRespWrapper.cls_selFields selRecordObj : fieldWrap.selFields){
            IContract_MetaData__c metadataObj 		= new IContract_MetaData__c();
            if(fieldNameAndMetadataMap.containsKey(selRecordObj.fieldName))
                metadataObj.Id 						= fieldNameAndMetadataMap.get(selRecordObj.fieldName).Id;
            metadataObj.Mapping_Configurations__c	= mapConfigObj.Id;
            metadataObj.Active__c                   = true;
            metadataObj.Field_Name__c				= selRecordObj.fieldName;
            metadataObj.Display_Name__c				= selRecordObj.displayName;
            metadataObj.DataType__c					= selRecordObj.dataType;
            if(String.isNotBlank(selRecordObj.length))
            metadataObj.Length__c					= Integer.valueOf(selRecordObj.length);
            String isMandatory                      = selRecordObj.mandatory;
            if( isMandatory.equalsIgnoreCase('Yes')) 
            metadataObj.Mandatory__c                = true;
            else metadataObj.Mandatory__c           = false;
            metadataObj.AllowedValues__c			= selRecordObj.allowedValues;
            metadataObj.Default_Value__c			= selRecordObj.defaultValue;
            metadataObj.Applicable_Module__c		= selRecordObj.applicableModules;
            metadataObj.Contract_Relationship__c	= selRecordObj.contractRelationship;
            metadataObj.Dependant_Fields__c 		= selRecordObj.dependantFields;
            if(selRecordObj.isDependent != null)
            metadataObj.Is_Dependent_Field__c 		= selRecordObj.isDependent;
            if(String.isNotBlank(selRecordObj.dataType)){
                String dataType 	= selRecordObj.dataType;
                String beforeStr 	= dataType.substringBefore(':');
                String afterStr  	= dataType.substringAfter(':');
                if(String.isNotBlank(beforeStr)) metadataObj.DataType__c		= beforeStr.normalizeSpace();
                if(String.isNotBlank(afterStr)) {
                    String defaultValueStr          = afterStr.normalizeSpace();
                    if(defaultValueStr.startsWith(':')) defaultValueStr = defaultValueStr.removeStart(':');
                    metadataObj.Default_Value__c	= defaultValueStr.normalizeSpace();
                }
            }
            if((metadataObj.AllowedValues__c).startsWith(':')) metadataObj.AllowedValues__c = metadataObj.AllowedValues__c.removeStart(':');
            metadataObj.AllowedValues__c    = metadataObj.AllowedValues__c.normalizeSpace();
            metadataList.add(metadataObj);
            fieldNameSet.add(selRecordObj.fieldName);
        }
        //make unselected fields Inactive.
        updateUncheckedFields(fieldNameSet, fieldNameAndMetadataMap);
        return metadataList;        
    }
    
    
    static void updateUncheckedFields(Set<String> fieldNameSet, Map<String, IContract_MetaData__c> fieldNameAndMetadataMap){
        List<IContract_MetaData__c> updateMetadataList 				= new List<IContract_MetaData__c>();
        for(String key : fieldNameAndMetadataMap.KeySet()){
			if(!fieldNameSet.contains(key)){
                    fieldNameAndMetadataMap.get(key).Active__c  = false;
                    updateMetadataList.add(fieldNameAndMetadataMap.get(key));           
                } 
        }
        
        if(!updateMetadataList.isEmpty()){
            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.icontractMetadatafields();        
            SecurityUtils.checkInsert(IContract_MetaData__c.SObjectType,requestFieldsList);
            SecurityUtils.checkUpdate(IContract_MetaData__c.SObjectType,requestFieldsList);
            try{
                    update updateMetadataList;   
                }catch(Exception e){
                    HandleBusinessException.captureError('FieldMappingControllerService', 'updateUncheckedFields', e);
                }
        }
    }
 
    
    //Purpose : To get existing selected fields for particular Mapping Config, to show them by default select on Page.
    public static List<String> getExistingSelFieldRecords(String selType, String selSubType){
        List<String> selFieldNameList						= new List<String>();
        List<IContract_MetaData__c> metadataRecList 		= new List<IContract_MetaData__c>();
        try{
        	metadataRecList									= FieldMappingControllerModel.getMetadataRecList(selType, selSubType);    
        }catch(Exception e){
            system.debug('e:::::'+e.getMessage());
        }
        
        for(IContract_MetaData__c metRecObj : metadataRecList){
            if(String.isNotBlank(metRecObj.Field_Name__c)) selFieldNameList.add(metRecObj.Field_Name__c);
        }
        return selFieldNameList;
    }
    
    
    //Purpose : Activate the Contract(Mapping Configuration Record)
    public static String activateContract(String contractId){
        Mapping_Configurations__c configRec 	= new Mapping_Configurations__c();
        configRec 								= FieldMappingControllerModel.getContractMappingConfigRecFromId(contractId);
        configRec.Status__c 					= Constants.MAPPING_CONFIG_ACTIVE_STATUS;
        try{
            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.fetchMappingConfigurationFields();        
            SecurityUtils.checkUpdate(Mapping_Configurations__c.SObjectType,requestFieldsList);
            
        	update configRec;
            return System.Label.Success_return_message;
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'activateContract', e);
            return e.getMessage();
        }        
    }


    //Purpose : Deactivate the Contract(Mapping Configuration Record)
    public static String deactivateContract(String contractId){
        Mapping_Configurations__c configRec     = new Mapping_Configurations__c();
        configRec                               = FieldMappingControllerModel.getContractMappingConfigRecFromId(contractId);
        configRec.Status__c                     = Constants.MAPPING_CONFIG_INACTIVE_STATUS;
        try{
            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.fetchMappingConfigurationFields();        
            SecurityUtils.checkUpdate(Mapping_Configurations__c.SObjectType,requestFieldsList);
            
            update configRec;
            return System.Label.Success_return_message;
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'deactivateContract', e);
            return e.getMessage();
        }        
    }
    
    
    //Purpose : Delete the Contract(Mapping Configuration Record)
    public static String deleteContract(String contractId){
        try{
            SecurityUtils.checkObjectIsDeletable(IContract_MetaData__c.SObjectType);
            
            delete [Select Id from IContract_MetaData__c where Mapping_Configurations__c =: contractId];
            return System.Label.Record_deleted_Successfully_Msg;
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'deleteContract', e);
            return e.getMessage();
        }
    }
    
    
    //Purpose : To Copy the Contract(Mapping Configuration record), into new Contract with
    //          different Type and Subtype(with all of its child records).
    public static String copyContract(String contractId, String selType, String selSubType){
        Mapping_Configurations__c configObj 	= new Mapping_Configurations__c();
        Mapping_Configurations__c newConfigObj 	= new Mapping_Configurations__c();
        try{
            String equery                 	= Utility.getDynamQuery('Mapping_Configurations__c' , 'id =: contractId');
            configObj 						= Database.query(equery);
        }catch(Exception e){}
        if(String.isNotBlank(configObj.Id)){
            try{
            	newConfigObj					              = FieldMappingControllerModel.getContractMappingConfigRec(selType, selSubType);    
                List<IContract_MetaData__c> metadataList      = new List<IContract_MetaData__c>();
                try{
                    metadataList    = FieldMappingControllerModel.getMetadataRecList(newConfigObj.Id);
                    if(!metadataList.isEmpty()) return System.Label.Mapping_found_for_particular_Type_and_Subtype_msg;
                }catch(Exception e){
                    HandleBusinessException.captureError('FieldMappingControllerService', 'copyContract', e);                    
                }
            }catch(Exception e){
                HandleBusinessException.captureError('FieldMappingControllerService', 'copyContract', e);                    
                return e.getMessage();
            }
            if(String.isBlank(newConfigObj.Id)) return System.Label.Selected_Type_and_Subtype_not_found_msg;
            else
            return createICOntractMetadataRecords(configObj.Id, newConfigObj.Id);
        }else{
         	return System.Label.Mapping_Config_Record_not_found_msg;   
        }
    }
    
    
    static String createICOntractMetadataRecords(String configObjId, String newConfigObjId){
        Map<Id, IContract_MetaData__c> newiContractMetadataMap 	= new Map<Id, IContract_MetaData__c>();
        List<IContract_MetaData__c> iContractMetadataList 		= new List<IContract_MetaData__c>();
        String equery                 							= Utility.getDynamQuery('IContract_MetaData__c' , 'Mapping_Configurations__c =: configObjId');
        try{
        	iContractMetadataList 									= Database.query(equery);    
        }catch(Exception e){}
        
        for(IContract_MetaData__c iContractMDObj : iContractMetadataList){
            IContract_MetaData__c iContractMDObjNew 	= new IContract_MetaData__c();
            iContractMDObjNew 							= iContractMDObj.clone(false, true);
            iContractMDObjNew.Mapping_Configurations__c	= newConfigObjId;
            newiContractMetadataMap.put(iContractMDObj.Id, iContractMDObjNew);
        }
        try{
            List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.icontractMetadatafields();        
            SecurityUtils.checkInsert(IContract_MetaData__c.SObjectType,requestFieldsList);

            if(!newiContractMetadataMap.isEmpty())
        	insert newiContractMetadataMap.values();
            return createValueMappingRecords(newiContractMetadataMap);
        }catch(Exception e){
            HandleBusinessException.captureError('FieldMappingControllerService', 'createICOntractMetadataRecords', e);                    
            return e.getMessage();
        }   
    }
    
    
    static String createValueMappingRecords(Map<Id, IContract_MetaData__c> newiContractMetadataMap){
        List<Value_Mapping__c> valueMappingList 	= new List<Value_Mapping__c>();
        List<Value_Mapping__c> newValueMappingList 	= new List<Value_Mapping__c>();
        Set<Id> newMDMapKeySet 						= newiContractMetadataMap.keySet();
		String equery								= Utility.getDynamQuery('Value_Mapping__c' , 'IContract_Field_Metadata__c IN: newMDMapKeySet');		
        try{
        	valueMappingList						= Database.query(equery);    
        }catch(Exception e){
            system.debug('Exception::::'+e.getMessage());
        }
        
        if(!valueMappingList.isEmpty()){ 
            for(Value_Mapping__c valMappingObj : valueMappingList){
                Value_Mapping__c newValMappingObj				= new Value_Mapping__c();
                newValMappingObj								= valMappingObj.clone(false, true);
                newValMappingObj.IContract_Field_Metadata__c	= newiContractMetadataMap.get(valMappingObj.IContract_Field_Metadata__c).Id;
                newValueMappingList.add(newValMappingObj);
            }
            try{
                List<Schema.SObjectField> requestFieldsList = FieldAccessibilityUtility.fetchValueMappingFields();        
	            SecurityUtils.checkInsert(Value_Mapping__c.SObjectType,requestFieldsList);
                insert newValueMappingList;
            }catch(Exception e){
                HandleBusinessException.captureError('FieldMappingControllerService', 'createValueMappingRecords', e);                    
				return e.getMessage();                
            }
        }
        return System.Label.Success_return_message;
    }
}