/*----------------------------------------------------------------------------
* Description :   This Helper is to store icontract metadata 
                  + field selection + field mapping for line item metadata.
* Created By  :   Jayanth B
* Created Date:   24/05/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class LineItemMappingRequestMetadataHelper {

    // Dynamic query used to get line item data from icontract field metadat to display on field selection component
    public static List<IContract_MetaData__c> getExistingLineItemData(boolean isItFromComponent){ 
        String Query         = '';
        boolean lineItemData = true;
        boolean isLineItemActive = true;
        
        Query                = 'Select Id, Field_Name__c,LineItem_Data__c,IsLineItemActive__c,AllowedValues__c,Applicable_Module__c,Contract_Relationship__c,DataType__c,SOT__c'+
            ' ,Default_Value__c,Dependant_Fields__c,Display_Name__c,Length__c,Mandatory__c,Mapping_Configurations__c,Mapping_Field__c,Mapping_Object__c,(Select id,Mapping_Field__c,Mapping_Value__c,IContract_Value__c,Field_Name__c From Value_Mappings__r)'+
            ' from IContract_MetaData__c'+
            ' where LineItem_Data__c=:lineItemData';
        
        if(isItFromComponent){            
            Query += ' AND IsLineItemActive__c=:isLineItemActive';
        }
        
        try{            
            List<IContract_MetaData__c> listOfLineItemMetaData = Database.query(Query);
            return listOfLineItemMetaData;
        }
        catch(Exception e){
            HandleBusinessException.captureError('LineItemMappingRequestMetadataHelper', 'getExistingLineItemData', e);
            return null;
        }
    }
    
    // To create/update lineItem data for icontract field metadata object
    @AuraEnabled
    public static String createLineItemFieldsMetadata(String fieldSelectedData){
        try{
            Map<String, IContract_MetaData__c> fieldNameAndMetadataMap 	= new Map<String, IContract_MetaData__c>();
            fieldSelectedData                                           = '{"selFields":' + fieldSelectedData + '}';
            //fields from page
            LineItemSelectedFieldsWrapper LineItemfieldWrap 	        = LineItemSelectedFieldsWrapper.parse(fieldSelectedData);
            
            // existing fields in database
            List<IContract_MetaData__c> lineItemExistingMetaData        = getExistingLineItemData(false);
            
            for(IContract_MetaData__c metadatObj : lineItemExistingMetaData){
                fieldNameAndMetadataMap.put(metadatObj.Field_Name__c , metadatObj);
            }
            
            List<IContract_MetaData__c> lineItemMetadataList = new List<IContract_MetaData__c>();
            
            for(LineItemSelectedFieldsWrapper.cls_selFields lineItemwrp : LineItemfieldWrap.selFields){
                IContract_MetaData__c metadataObj 		= new IContract_MetaData__c();
                //checking if data is already present or not for insert or update operation
                if(fieldNameAndMetadataMap.containsKey(lineItemwrp.fieldName))
                metadataObj.Id 						    = fieldNameAndMetadataMap.get(lineItemwrp.fieldName).Id;
                
                metadataObj.Field_Name__c				= lineItemwrp.fieldName;
                metadataObj.Display_Name__c				= lineItemwrp.displayName;
                metadataObj.DataType__c					= lineItemwrp.dataType;
                metadataObj.AllowedValues__c			= lineItemwrp.allowedValues;
                metadataObj.Default_Value__c			= lineItemwrp.defaultValue;
                metadataObj.Applicable_Module__c		= lineItemwrp.applicableModules;
                metadataObj.Contract_Relationship__c	= lineItemwrp.lineItemRelationship;
                metadataObj.Dependant_Fields__c 		= lineItemwrp.dependantFields;
                metadataObj.LineItem_Data__c            = true;
                metadataObj.IsLineItemActive__c         = boolean.valueOf(lineItemwrp.isSelected);
                if(String.isNotBlank(lineItemwrp.length))
                    metadataObj.Length__c					= Integer.valueOf(lineItemwrp.length);
                if(String.isNotBlank(lineItemwrp.mandatory) && lineItemwrp.mandatory == system.label.Madatory_is_true_value)
                    metadataObj.Mandatory__c				= true;
                
                lineItemMetadataList.add(metadataObj);
            }
            
            //upsert value icontract data
            List<Schema.SObjectField> icontractMetadataFieldsList = FieldAccessibilityUtility.icontractMetadatafields();        
            SecurityUtils.checkInsert(IContract_MetaData__c.SObjectType,icontractMetadataFieldsList);
            SecurityUtils.checkUpdate(IContract_MetaData__c.SObjectType,icontractMetadataFieldsList);
            
            //upsert operation to update old data and insert new data based on changes made from LineItemfieldSelection component
            if(!lineItemMetadataList.isEmpty())
                upsert lineItemMetadataList;
            
            return fieldSelectedData;
        }Catch(Exception e){
            HandleBusinessException.captureError('LineItemMappingRequestMetadataHelper', 'createLineItemFieldsMetadata', e);
            return 'Exception';
        }
        
    }
    
    // used to save mapped icontract field data with salesforce line item data
    public static String mappingObjectFieldForLineItemSelectedFields(String mappedFieldsData){
        try{
            Map<String, IContract_MetaData__c> fieldNameAndMetadataMap 	= new Map<String, IContract_MetaData__c>();
            mappedFieldsData                                            = '{"mappedFields":' + mappedFieldsData + '}';
            LineItemFieldMappingWrapper LineItemfieldWrap 	            = LineItemFieldMappingWrapper.parse(mappedFieldsData);//wrapper of fields mapped from icontract to salesforce
            
            List<IContract_MetaData__c> lineItemExistingMetaData        = getExistingLineItemData(true);// to get only active lineitem metadata details from icontract feild metadata object
            
            for(IContract_MetaData__c metadatObj : lineItemExistingMetaData){
                fieldNameAndMetadataMap.put(metadatObj.Field_Name__c , metadatObj);
            }
            
            List<IContract_MetaData__c> lineItemMetadataList             = new List<IContract_MetaData__c>();
            List<Value_Mapping__c> valueMappingUpdate = new List<Value_Mapping__c>();
            for(LineItemFieldMappingWrapper.cls_mappedField lineItemwrp : LineItemfieldWrap.mappedFields){
                IContract_MetaData__c metadataObj 		= new IContract_MetaData__c();
                
                if(fieldNameAndMetadataMap.containsKey(lineItemwrp.fieldName)){
                    metadataObj.Id 						= fieldNameAndMetadataMap.get(lineItemwrp.fieldName).Id;
                    
                    if(lineItemwrp.mappingField1 != fieldNameAndMetadataMap.get(lineItemwrp.fieldName).Mapping_Field__c){
                        // if value mapping is present for particular fields and on change of field mapping to erase the mapped value for that particular field in value mapping child object of icontract field metadata
                        if(fieldNameAndMetadataMap.get(lineItemwrp.fieldName).Value_Mappings__r.size() >= 0){
                       for(Value_Mapping__c vmp : fieldNameAndMetadataMap.get(lineItemwrp.fieldName).Value_Mappings__r){
                           vmp.Mapping_Field__c = lineItemwrp.mappingField1;
                           vmp.Mapping_Value__c = '';
                           valueMappingUpdate.add(vmp);
                       }
                        }
                    }else{
                      //  
                    }
                    
                    
                    metadataObj.Mapping_Object__c       = lineItemwrp.mappingObject;
                    metadataObj.Mapping_Field__c        = lineItemwrp.mappingField1;
                    if(lineItemwrp.SOT == true){metadataObj.SOT__c= System.label.Salesfroce;}else{metadataObj.SOT__c= System.label.iContract;}//based on SOT true/false setting value to icontract or salesforce
                    lineItemMetadataList.add(metadataObj);
                }
                
            }
            
            
            //update value icontract data
            List<Schema.SObjectField> icontractMetadataFieldsList = FieldAccessibilityUtility.icontractMetadatafields();
            List<Schema.SObjectField> valueMappingFieldsList = FieldAccessibilityUtility.fetchValueMappingFields();
            SecurityUtils.checkUpdate(IContract_MetaData__c.SObjectType,icontractMetadataFieldsList);
            SecurityUtils.checkUpdate(Value_Mapping__c.SObjectType,valueMappingFieldsList);
            
            if(!lineItemMetadataList.isEmpty())
                update lineItemMetadataList;
            
            if(!valueMappingUpdate.isEmpty())
                update valueMappingUpdate;
                
            return System.label.SUCCESS;
        }Catch(Exception e){
            HandleBusinessException.captureError('LineItemMappingRequestMetadataHelper', 'mappingObjectFieldForLineItemSelectedFields', e);
            return System.label.Exception;
        }
        
    }
    

    

}