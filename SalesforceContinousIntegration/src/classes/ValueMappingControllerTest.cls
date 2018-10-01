/***********************************************************************************************
Author : Siva Krishna Reddy B
Purpose : This class is used to define unit test for Value Mapping Controller.
Created Date : 31/05/2018
Lastmodified By : 
Reason: 
*****************************************************************************************************/
@isTest
public class ValueMappingControllerTest {
	
    private class CenterNameUpdateException extends Exception {}

    //Variables
    public static Mapping_Configurations__c mapConfig;
    public static IContract_MetaData__c icontractField;
    public static List<IContract_MetaData__c> icontractFieldList;
    public static Value_Mapping__c vm;
    public static Icontract_and_Salesforce_Field_Mapping__mdt fieldmappingMetadata;
    //Init method to create data
    public static void init(){
        
        icontractFieldList = new List<IContract_MetaData__c>();
        //Create mapConfig data
        mapConfig = Utility_Test.createMapConfig('Airline Operations Agreement','Goods and Services','Prospecting',
                                                 'Active',true,true,true,'Airline Operations Agreement-Goods and Services');
        insert mapConfig;
        system.assertNotEquals(null, mapConfig);
        //Create Icontract Medadata
        icontractField =  Utility_Test.createIContractFieldData(true, 'US, EMEA, APAC, ANZ', 'list', 'Region', 'Region', 
                                                                false, false, true, mapConfig.Id, 'Contract', 'Status', 'Opportunity', 
                                                                'StageName', 'salesforce');
        insert icontractField;
        icontractFieldList.add(icontractField);
        system.assertNotEquals(null, icontractField);
        
        //Create Value Mapping data
        String vmExternalId = mapConfig.Type__c+'-'+mapConfig.SubType__c+'-'+'Region'+'-'+'US'+'-'+'Activated';
        vm = Utility_Test.createValueMapping('Region', icontractField.Id, 'US', 'Status', 'Contract', 'Activated', 
                                             'StageName', 'Opportunity', 'Closed Won', vmExternalId);
        insert vm;
        system.assertNotEquals(null, vm);
       
    }
    
    //with all data
    @isTest static void valueMappingInsert() {
        init();

        // call to getIcontractFields insert method
        ValueMappingController.getIContractFields(mapConfig.Id);        		
        
        //Call to get picklist values 
        List<String> allowedValues = new List<String>();
        allowedValues =icontractField.AllowedValues__c.split(',');
        List<ValueMappingController.objFieldWrapper> vmobjectWrapList = new List<ValueMappingController.objFieldWrapper>();
        ValueMappingController.objFieldWrapper vmobjectWrap = new ValueMappingController.objFieldWrapper();
        vmobjectWrap.IContractFieldName =icontractField.Field_Name__c;
        vmobjectWrap.fieldName1 = icontractField.Mapping_Field__c;
        vmobjectWrap.ObjectName1 = icontractField.Mapping_Object__c;
        vmobjectWrap.fieldName2 = icontractField.Mapping_Field_2__c;
        vmobjectWrap.ObjectName2 = icontractField.Mapping_Object_2__c;
        vmobjectWrapList.add(vmobjectWrap);
        String objectWrapJSON = JSON.serialize(vmobjectWrapList);
        ValueMappingController.getPicklistValues(mapConfig.Id,objectWrapJSON,allowedValues);
        
        //Call to get all Picklist values
        ValueMappingController.getAllPicklistValues(mapConfig.Id,icontractFieldList);
        
        //Call to get save values
        List<String> fieldvalues1 = new List<String>();
        fieldvalues1.add('US');
        fieldvalues1.add('INDIA');
        fieldvalues1.add('ANZ');
        fieldvalues1.add('DUBAI');
        fieldvalues1.add('UK');
        List<String> fieldvalues2 = new List<String>();
        fieldvalues2.add('US');
        fieldvalues2.add('INDIA');
        fieldvalues2.add('ANZ');
        fieldvalues2.add('DUBAI');
        fieldvalues2.add('UK');
        List<ValueMappingController.pickValuesWrapper> pickValWrapList = new List<ValueMappingController.pickValuesWrapper>();
        ValueMappingController.pickValuesWrapper pickValWrap = new ValueMappingController.pickValuesWrapper('Region','US','Contract','Status', 'US',fieldvalues1, 
                                                                                                             'Opportunity','StageName', 'US', fieldvalues2);
        pickValWrapList.add(pickValWrap);
        String valueWrapJSON = JSON.serialize(pickValWrapList);
        ValueMappingController.savePickListValues(valueWrapJSON,icontractFieldList);
    }
    
    //Exception scenarios
    @isTest static void valueMappingException(){
        init();
        
        // call to getIcontractFields Exception method        
        ValueMappingController.getIContractFields(mapConfig.Id);
        
        //Call to get picklist values 
        List<String> allowedValues = new List<String>();
        allowedValues =icontractField.AllowedValues__c.split(',');        
        try{
            ValueMappingController.getPicklistValues(mapConfig.Id,null,allowedValues);
        }
        Catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
        }
        
        //Call to get Save picklist values
        try{
            ValueMappingController.savePickListValues(null,icontractFieldList);
        }
        Catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
        }
		
    }
    
    //Other scenarios
    @isTest static void valueMappingTest(){
    	init();                
        icontractField.AllowedValues__c = null;
        update icontractField;
        
        //call to getIcontractFields with null values. 
        ValueMappingController.getIContractFields(mapConfig.Id);
        
        //Call to get all Picklist values
        ValueMappingController.getAllPicklistValues(mapConfig.Id,icontractFieldList);
        try{
            ValueMappingController.getAllPicklistValues(null,icontractFieldList);
        }
        Catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
        }        
        
    }
}