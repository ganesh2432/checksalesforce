/*----------------------------------------------------------------------------
 * Description :   This controller to query data from DB
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   20/05/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class ValueMappingControllerModel {

    //Method to query mapping configurations
    public static List<String>  getFieldMapping(){
       
       List<String> enumList = new List<String>();
       //query custom metadata for list/enum types.
       List<Icontract_and_Salesforce_Field_Mapping__mdt> customMetaDataList = [select id,DeveloperName,Salesforce_Field_Datatype__c from Icontract_and_Salesforce_Field_Mapping__mdt where Salesforce_Field_Datatype__c like '%PICKLIST%'] ;
       system.debug(customMetaDataList);
       for(Icontract_and_Salesforce_Field_Mapping__mdt cmd:customMetaDataList){
            enumList.add(cmd.DeveloperName);
       }        
       return enumList;
    }
    
    //Method to query icontract Field data
    public static List<IContract_MetaData__c> getIcontractFields(List<String> enumList,String mapConfigId){
       List<IContract_MetaData__c> IContractFieldList = new List<IContract_MetaData__c>();
       IContractFieldList = [select id,Mapping_Field__c,Mapping_Field_2__c,Mapping_Object__c,Mapping_Object_2__c,
                             Field_Name__c,Display_Name__c,DataType__c,AllowedValues__c,Active__c,Mapping_Configurations__r.Type__c,Mapping_Configurations__r.SubType__c from IContract_MetaData__c where Mapping_Configurations__r.Id =:mapConfigId and DataType__c IN:enumList and Active__c=true and (Mapping_Field__c != '' OR Mapping_Field_2__c != '')];
      
        for(Integer i=0;i<IContractFieldList.size();i++){
            if(IContractFieldList[i].AllowedValues__c == null || IContractFieldList[i].AllowedValues__c == ''){
            	IContractFieldList.remove(i);
            }
        }
       system.debug(IContractFieldList);
       return IContractFieldList; 
    }
    
    //Method to query type and subtype
    public static Mapping_Configurations__c getMappingConfig(String MappingConfigId){
        system.debug('the value is'+MappingConfigId); 
        Mapping_Configurations__c mappingConfig = new Mapping_Configurations__c();
        mappingConfig= [select id,Type__c,SubType__c from Mapping_Configurations__c where Id=:MappingConfigId];
        return mappingConfig;
    }  
    
    //Method to query valueMappinglist.
    public static List<Value_Mapping__c> getValueMapping(String iContractFieldName,String MappingConfigId){
        List<Value_Mapping__c> valueMappingList = new List<Value_Mapping__c>();
        valueMappingList = [select id,Mapping_Field__c,Mapping_Object__c,Mapping_Value__c,Field_Name__c,IContract_Value__c,
                                Mapping_Field2__c,Mapping_Object2__c,Mapping_Value2__c from Value_Mapping__c where Field_Name__c=:iContractFieldName AND IContract_Field_Metadata__r.Mapping_Configurations__r.Id=:MappingConfigId];
    	return valueMappingList; 
    }
    
    //Method to query allvalueMappinglist.
    public static List<Value_Mapping__c> getAllValueMapping(String MappingConfigId){
        List<Value_Mapping__c> valueMappingList = new List<Value_Mapping__c>();
        valueMappingList = [select id,Mapping_Field__c,Mapping_Object__c,Mapping_Value__c,Field_Name__c,IContract_Value__c,
                                Mapping_Field2__c,Mapping_Object2__c,Mapping_Value2__c from Value_Mapping__c where IContract_Field_Metadata__r.Mapping_Configurations__r.Id=:MappingConfigId];
    	return valueMappingList; 
    }
}