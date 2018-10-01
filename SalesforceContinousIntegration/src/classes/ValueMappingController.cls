/*----------------------------------------------------------------------------
 * Description :   This controller to used for value mapping component to fetch
 *                 data from DB and save the value mapping.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   10/05/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class ValueMappingController {
	
    //Variable declaration
    public static List<pickValuesWrapper> pickValuesList;
    public static List<objFieldWrapper> objFieldWrap;
    public static List<pickValuesWrapper> finalPickValuesList;
    public static List<Value_Mapping__c> finalValueList;
    public static Map<String,Value_Mapping__c> valueMappingMap;
    public static List<IContract_MetaData__c> IContractFieldList;
    public static List<String> unMappedvaluesList;
    public static Set<String> unMappedvaluesSet;
    @AuraEnabled
    public static List<IContract_MetaData__c> getIContractFields(String mapConfigId){              
        try{
           //query field mapping from custom metadata
           List<String> enumList = ValueMappingControllerModel.getFieldMapping();
           //query Icontract fields
           IContractFieldList = new List<IContract_MetaData__c>();
           IContractFieldList = ValueMappingControllerModel.getIcontractFields(enumList,mapConfigId);
        }
        catch(Exception e){
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ValueMappingController', 'getIContractFields', e);
            //throw new CustomException(errorMessage);
        }
        return IContractFieldList; 
    }
    
    @AuraEnabled
    public static List<pickValuesWrapper> getPicklistValues(String MappingConfigId, String JsonobjFieldWrap,List<String> AllowedValues){
        
        try{
            
            pickValuesList = new List<pickValuesWrapper>();
            valueMappingMap = new Map<String,Value_Mapping__c>();
            
            //deserilaize the JSON string
            objFieldWrap = (List<objFieldWrapper>)System.JSON.deserialize(JsonobjFieldWrap, List<objFieldWrapper>.Class);
            String iContractFieldName = objFieldWrap[0].iContractFieldName; 
            system.debug('the obj wrapper'+objFieldWrap);
            
            //Query data using the Mapping Config Id.
            Mapping_Configurations__c mappingConfig = ValueMappingControllerModel.getMappingConfig(MappingConfigId);
            
            //Query data from Value Mapping object.
            List<Value_Mapping__c> valueMappingList= ValueMappingControllerModel.getValueMapping(iContractFieldName,MappingConfigId);
            
            if(valueMappingList.size()>0){
                for(Value_Mapping__c vm:valueMappingList){
                    valueMappingMap.put(vm.IContract_Value__c,vm);
                }    
            }
            
            List<String> fieldValues1 = new List<String>();
            List<String> fieldValues2 = new List<String>();
            //get the picklist values from schema
            if(objFieldWrap[0].fieldName1 != null && objFieldWrap[0].fieldName1 != 'Create New Field'){
                fieldValues1 = getEnumListValues(objFieldWrap[0].ObjectName1,objFieldWrap[0].fieldName1);
            }          
            if(objFieldWrap[0].fieldName2 != null && objFieldWrap[0].fieldName2 != 'Create New Field'){
               fieldvalues2 = getEnumListValues(objFieldWrap[0].ObjectName2,objFieldWrap[0].fieldName2); 
            } 
            system.debug('the fieldvalues1'+fieldValues1);
            system.debug('the fieldvalues2'+fieldValues2);

            for(String str:AllowedValues){
                Value_Mapping__c vm = valueMappingMap.get(str.trim());                
                if(vm!=null){
                     pickValuesWrapper pvw = new pickValuesWrapper(vm.Field_Name__c,vm.IContract_Value__c,vm.Mapping_Object__c,
                                                                          vm.Mapping_Field__c,vm.Mapping_Value__c,fieldValues1,vm.Mapping_Object2__c,
                                                                          objFieldWrap[0].fieldName2,vm.Mapping_Value2__c,fieldValues2);
                     pickValuesList.add(pvw);
                     system.debug(pvw);
                }
                else{
                   pickValuesWrapper pvw = new pickValuesWrapper(objFieldWrap[0].IContractFieldName,str,objFieldWrap[0].ObjectName1,
                                                                          objFieldWrap[0].fieldName1,'',fieldValues1,objFieldWrap[0].ObjectName2,
                                                                          objFieldWrap[0].fieldName2,'',fieldValues2); 
                    pickValuesList.add(pvw);
                    system.debug(pvw); 
                }                
            }
                        
            
        }
        Catch(Exception e){
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ValueMappingController', 'getPicklistValues', e);
            //throw new CustomException(errorMessage);
        }
        
        return pickValuesList;        
    }
    
    //Method to get all picklist values.
    @AuraEnabled
    public static List<String> getAllPicklistValues(String MappingConfigId,List<IContract_MetaData__c> IContractFieldData){
        
        try{
                       
            valueMappingMap = new Map<String,Value_Mapping__c>();            
            unMappedvaluesSet = new Set<String>();
            unMappedvaluesList = new List<String>();
			system.debug('the value is'+MappingConfigId);            
            //Query data using the Mapping Config Id.
            Mapping_Configurations__c mappingConfig = ValueMappingControllerModel.getMappingConfig(MappingConfigId);
            
            //Query data from Value Mapping object.
            List<Value_Mapping__c> valueMappingList= ValueMappingControllerModel.getAllValueMapping(MappingConfigId);
            
            if(valueMappingList.size()>0){
                for(Value_Mapping__c vm:valueMappingList){
                    valueMappingMap.put(vm.IContract_Value__c+vm.Field_Name__c,vm);
                }    
            }
                                   
            for(IContract_MetaData__c icm: IContractFieldData){
                String AllowedValues = icm.AllowedValues__c;
                List<String> AllValues = new List<String>();
                if(AllowedValues != null && AllowedValues != ''){
                	AllValues = AllowedValues.split(',');                               
                    for(String str: AllValues){
                        String finalString = str+icm.Field_Name__c;
                        Value_Mapping__c vm = valueMappingMap.get(finalString.trim());
                        if(vm!=null){
                            if(vm.Mapping_Field__c != icm.Mapping_Field__c || vm.Mapping_Field2__c != icm.Mapping_Field_2__c){
                                unMappedvaluesSet.add(icm.Display_Name__c);
                            }
                            if(vm.Mapping_Value__c == null && vm.Mapping_Value__c =='' && vm.Mapping_Value2__c ==null && vm.Mapping_Value2__c ==''){
                                unMappedvaluesSet.add(icm.Display_Name__c);
                            }                        
                        }
                        else{
                            unMappedvaluesSet.add(icm.Display_Name__c);    
                        }                    
                    }
            	}
                else{
                    unMappedvaluesSet.add(icm.Display_Name__c);  
                }
             system.debug('...unMappedvaluesSet'+unMappedvaluesSet);                
            }
            unMappedvaluesList.addAll(unMappedvaluesSet);
            if(unMappedvaluesList.isEmpty()){            
            	Mapping_Configurations__c mappingConfigObj  = new Mapping_Configurations__c(Id = MappingConfigId, Stage__c = Constants.STAGE3_MAP_CONFIG);
                update mappingConfigObj; 
            } 
        }
        Catch(Exception e){
            String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ValueMappingController', 'getAllPicklistValues', e);
            //throw new CustomException(errorMessage);
        }
                           
        return unMappedvaluesList;        
    }
    
    //Method to save value mapping details in salesforce
    @AuraEnabled
    public static void savePickListValues(String JSONSaveDetails,List<IContract_MetaData__c> IContractList){
        
        try{
            finalValueList = new List<Value_Mapping__c>();
            //deserilaize the JSON string
            finalPickValuesList = new List<pickValuesWrapper>();        
            finalPickValuesList = (List<pickValuesWrapper>)System.JSON.deserialize(JSONSaveDetails, List<pickValuesWrapper>.Class);
            system.debug('the final pickvals wrapper'+finalPickValuesList);
            
            //upsert value mapping data
            List<Schema.SObjectField> valueMappingFieldsList = FieldAccessibilityUtility.fetchValueMappingFields();
            SecurityUtils.checkInsert(Value_Mapping__c.SObjectType,valueMappingFieldsList);
            SecurityUtils.checkUpdate(Value_Mapping__c.SObjectType,valueMappingFieldsList);
            for(pickValuesWrapper pvw:finalPickValuesList){
            	
                    Value_Mapping__c vm = new Value_Mapping__c();
                    vm.Field_Name__c      = pvw.IContractFieldName;
                    vm.IContract_Value__c = pvw.IContractValue;
                    vm.Mapping_Object__c  = pvw.objName1;                    
                    if(pvw.Value1 !='Select'){
                        vm.Mapping_Value__c = pvw.Value1;
                    }
                    vm.Mapping_Object2__c  = pvw.objName2;                    
                    if(pvw.Value2!='Select'){
                        vm.Mapping_Value2__c = pvw.Value2;
                    }
                	for(IContract_MetaData__c icm:IContractList){
                        if(icm.Field_Name__c == pvw.IContractFieldName){
                        	vm.IContract_Field_Metadata__c = icm.id;
                            vm.Mapping_Field2__c   = icm.Mapping_Field_2__c;
                            vm.Mapping_Field__c   = icm.Mapping_Field__c;
                            vm.ValueMappingExternalID__c = icm.Mapping_Configurations__r.Type__c+'-'+icm.Mapping_Configurations__r.SubType__c+'-'+pvw.IContractFieldName+'-'+pvw.IContractValue+'-'+pvw.Value1;
                        }
       				}                    
                    finalValueList.add(vm);                                 
            }
            upsert finalValueList ValueMappingExternalID__c;
            
    	}
        Catch(Exception e){
        	String errorMessage = e.getMessage();
            HandleBusinessException.captureError('ValueMappingController', 'savePickListValues', e);
            //throw new CustomException(errorMessage);    
        }
    }
    
   
    
    //Wrapper to define structure objects & fields wrapper. 
    public class objFieldWrapper{
        @AuraEnabled
        public String IContractFieldName{get;set;}
        @AuraEnabled
        public String ObjectName1{get;set;}
        @AuraEnabled
        public String fieldName1{get;set;}
        @AuraEnabled
        public String ObjectName2{get;set;}
        @AuraEnabled
        public String fieldName2{get;set;}
    }
    
    //Wrapper to define structure of picklist values wrapper.
    public class pickValuesWrapper{
        @AuraEnabled
        public String IContractFieldName{get;set;}
        @AuraEnabled
        public String IContractValue{get;set;}
        @AuraEnabled
        public String objName1{get;set;}
        @AuraEnabled
        public String fieldName1{get;set;}
        @AuraEnabled
        public String Value1{get;set;}
        @AuraEnabled
        public List<String> fieldValues1{get;set;}
        @AuraEnabled
        public String objName2{get;set;}
        @AuraEnabled
        public String fieldName2{get;set;}
        @AuraEnabled
        public String Value2{get;set;}
        @AuraEnabled
        public List<String> fieldValues2{get;set;}
        
        public pickValuesWrapper(String IContractFieldName, String IContractValue,String objName1, String fieldName1, String Value1, List<String> fieldValues1,
                                 String objName2, String fieldName2, String Value2, List<String> fieldValues2){
            this.IContractFieldName = IContractFieldName;
            this.IContractValue = IContractValue;                        
            this.objName1 = objName1;
            this.fieldName1 = fieldName1;
            this.Value1 = Value1;
            this.fieldValues1 = fieldValues1;
            this.objName2 = objName2;
            this.fieldName2 = fieldName2;
            this.Value2 = Value2;
            this.fieldValues2 = fieldValues2;                        
        }
        
        
    }
    
    //Method to get picklist values.
    public static list<String> getEnumListValues(String ObjectApiName,String FieldApiName){
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApiName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();        
        List<Schema.PicklistEntry> pick_list_values = field_map.get(FieldApiName).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) { 
        	lstPickvals.add(a.getValue());
        }
        return lstPickvals;
    }
    
    
}