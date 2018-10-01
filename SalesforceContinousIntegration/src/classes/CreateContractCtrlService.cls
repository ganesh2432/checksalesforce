public class CreateContractCtrlService {

    static Map<String , Create_Contract_API_Mapping__mdt> contractHeaderMap;
    static Map<String , Create_Contract_API_Mapping__mdt> contractMap;
    static Set<String> standardMappedFieldsSet;
    static Map<String, List<Value_Mapping__c>> apiAndValueMappingMap;
    
    public static CreateContractWrapper.cls_contract mapFields(CreateContractWrapper.cls_contract contractWrapObj, String type, String subType, Contract contractObj){
        contractHeaderMap													= new Map<String , Create_Contract_API_Mapping__mdt>();
        contractMap															= new Map<String , Create_Contract_API_Mapping__mdt>();
        standardMappedFieldsSet 											= new Set<String>();
        List<Create_Contract_API_Mapping__mdt> createContractMappingCMList 	= new List<Create_Contract_API_Mapping__mdt>();

        createContractMappingCMList											= CreateContractCtrlModel.getContractMappingCMList();
        prepareContractMaps(createContractMappingCMList);
//        CreateContractWrapper.cls_contract contractWrapObj					= new CreateContractWrapper.cls_contract();
        contractWrapObj														= mapContractHeaderFields(contractWrapObj, type, subType, contractObj);
        contractWrapObj														= mapContractFields(contractWrapObj, type, subType, contractObj);
        contractWrapObj														= mapContractCustomFields(contractWrapObj, type, subType, contractObj);
        contractWrapObj														= mapContractDependentFields(contractWrapObj, type, subType, contractObj);
        contractWrapObj														= mapContractParties(contractWrapObj, type, subType, contractObj);
        if(contractObj.Allow_Opportunity_LineItem_s__c)
        contractWrapObj														= mapLineItems(contractWrapObj, type, subType, contractObj);
        return contractWrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapContractHeaderFields(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        Map<String, String> standardField 				= new Map<String, String>();
        Set<String> contractMappingFieldSet 			= new Set<String>();
        List<IContract_MetaData__c> metadataList 		= new List<IContract_MetaData__c>();
        Map<String, String> apiAndContractFieldNameMap	= new Map<String, String>();
        
        if(!contractHeaderMap.isEmpty()){
            for(Create_Contract_API_Mapping__mdt mdtObj: contractHeaderMap.values()){
                if(String.isNotBlank(mdtObj.Mapping_Contract_Field__c)){
                    contractMappingFieldSet.add(mdtObj.Mapping_Contract_Field__c);
                }
            }
            metadataList 	= CreateContractCtrlModel.getMetadataList(type, subType, contractMappingFieldSet);
            if(!metadataList.isEmpty()){
                apiAndContractFieldNameMap	= prepareApiAndContractFieldNameMap(metadataList);
            }
            for(Create_Contract_API_Mapping__mdt mdtObj: contractHeaderMap.values()){
                String value = '';
                if(String.isNotBlank(mdtObj.Mapping_Contract_Field__c)){
                    if(apiAndContractFieldNameMap.containsKey(mdtObj.Mapping_Contract_Field__c)){
                        if(String.isNotBlank(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c))){
                            if(String.isNotBlank(String.valueOf(contractObj.get(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c))))){
                                try{
                                    Date d = (Date)contractObj.get(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c));
                                    value = String.valueOf(d);
                                }catch(Exception e){}
                                if(String.isBlank(value))
                                value 	= String.valueOf(contractObj.get(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c)));
                                if(apiAndValueMappingMap.containsKey(mdtObj.Mapping_Contract_Field__c)){
                                    String newValue	= '';
                                    for(Value_Mapping__c valueMappingObj : apiAndValueMappingMap.get(mdtObj.Mapping_Contract_Field__c)){
                                        if(value == valueMappingObj.Mapping_Value__c){
                                            newValue = valueMappingObj.IContract_Value__c;  
                                            break;
                                        }
                                    }
                                    value = newValue;
                                }
                            }
                        }
                    }
                }
                if(mdtObj.MasterLabel == 'type') value = contractObj.Type__c;
                if(mdtObj.MasterLabel == 'subType') value = contractObj.SubType__c;   
                standardField.put(mdtObj.MasterLabel, value);
            }
        }
        wrapObj.contractHeaders 						= standardField;
        return wrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapContractFields(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        Set<String> contractMappingFieldSet 			= new Set<String>();
        List<IContract_MetaData__c> metadataList 		= new List<IContract_MetaData__c>();
        Map<String, String> apiAndContractFieldNameMap	= new Map<String, String>();
        if(!contractMap.isEmpty()){
            for(Create_Contract_API_Mapping__mdt mdtObj: contractMap.values()){
                if(String.isNotBlank(mdtObj.Mapping_Contract_Field__c)){
                    contractMappingFieldSet.add(mdtObj.Mapping_Contract_Field__c);
                }
            }
            metadataList 	= CreateContractCtrlModel.getMetadataList(type, subType, contractMappingFieldSet);
            if(!metadataList.isEmpty()){
                apiAndContractFieldNameMap	= prepareApiAndContractFieldNameMap(metadataList);
            }
            
            for(Create_Contract_API_Mapping__mdt mdtObj: contractMap.values()){
                String value = '';
                if(String.isNotBlank(mdtObj.Mapping_Contract_Field__c)){
                    if(apiAndContractFieldNameMap.containsKey(mdtObj.Mapping_Contract_Field__c)){
                        if(String.isNotBlank(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c))){
                            if(String.isNotBlank(String.valueOf(contractObj.get(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c))))){
                                value 	= String.valueOf(contractObj.get(apiAndContractFieldNameMap.get(mdtObj.Mapping_Contract_Field__c)));
                                if(apiAndValueMappingMap.containsKey(mdtObj.Mapping_Contract_Field__c)){
                                    String newValue	= '';
                                    for(Value_Mapping__c valueMappingObj : apiAndValueMappingMap.get(mdtObj.Mapping_Contract_Field__c)){
                                        if(value == valueMappingObj.Mapping_Value__c){
                                          	newValue = valueMappingObj.IContract_Value__c;  
                                            break;
                                        }
                                    }
                                    value = newValue;
                                }
                            }
                        }
                    }
                    if(mdtObj.MasterLabel == 'contractId'){
                        wrapObj.contractId	= value;
                    }
                    if(mdtObj.MasterLabel == 'externalId'){
                        wrapObj.externalId	= contractObj.Id;
                    }
                    if(mdtObj.MasterLabel == 'isAmendment'){
                        wrapObj.isAmendment	= value;
                    }
                    if(mdtObj.MasterLabel == 'createdOn'){
                        wrapObj.createdOn	= value;
                    }
                    if(mdtObj.MasterLabel == 'updatedOn'){
                        wrapObj.updatedOn	= value;
                    }
                    if(mdtObj.MasterLabel == 'byPassNegotiateCycle'){
                        wrapObj.byPassNegotiateCycle	= value;
                    }
                    if(mdtObj.MasterLabel == 'byPassAuthoringReview'){
                        wrapObj.byPassAuthoringReview	= value;
                    }
                    if(mdtObj.MasterLabel == 'contractModule'){
                        wrapObj.contractModule	= value;
                    }
                }
            }
        }else{
            wrapObj.contractId				= '';
            wrapObj.externalId				= '';
            wrapObj.isAmendment				= '';
            wrapObj.createdOn				= '';
            wrapObj.updatedOn				= '';
            wrapObj.byPassNegotiateCycle	= '';
            wrapObj.byPassAuthoringReview	= '';
            wrapObj.contractModule			= '';
        }
        return wrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapContractCustomFields(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        List<CreateContractWrapper.cls_metaDataField> metaDataField 	= new List<CreateContractWrapper.cls_metaDataField>();
        List<IContract_MetaData__c> metadataList 						= new List<IContract_MetaData__c>();
        metadataList													= CreateContractCtrlModel.getMetadataList(type, subType);
        for(IContract_MetaData__c metadataObj : metadataList){
            if(!standardMappedFieldsSet.contains(metadataObj.Field_Name__c)){
                CreateContractWrapper.cls_metaDataField metadataFieldObj 		= new CreateContractWrapper.cls_metaDataField();
                metadataFieldObj.fieldName 										= metadataObj.Field_Name__c;
                if(metadataObj.Mapping_Field__c != null){
                    if(contractObj.get(metadataObj.Mapping_Field__c) != null)
                        metadataFieldObj.fieldValue 								= String.valueOf(contractObj.get(metadataObj.Mapping_Field__c));
                    else
                        metadataFieldObj.fieldValue									= '';  
                    if(!metadataObj.Value_Mappings__r.isEmpty()){
                        String newValue	= '';
                        for(Value_Mapping__c valueMappingObj : metadataObj.Value_Mappings__r){
                            if(metadataFieldObj.fieldValue == valueMappingObj.Mapping_Value__c){
                                newValue = valueMappingObj.IContract_Value__c;  
                                break;
                            }
                        }
                        if(contractObj.get(metadataObj.Mapping_Field__c) != null)
                            metadataFieldObj.fieldValue 								= newValue;
                        else
                            metadataFieldObj.fieldValue									= ''; 
                    }
                }else{
                    metadataFieldObj.fieldValue									= '';   
                }
                if(String.isNotBlank(metadataFieldObj.fieldValue))
                metaDataField.add(metadataFieldObj);
            }            
        }
        CreateContractWrapper.cls_metaDataFields metadataFields 		= new CreateContractWrapper.cls_metaDataFields();
        metadataFields.metaDataField									= metaDataField;
        CreateContractWrapper.cls_contractDetails contDetails 			= new CreateContractWrapper.cls_contractDetails();
        contDetails.metaDataFields										= metadataFields;
        wrapObj.contractDetails 										= contDetails;
        return wrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapContractDependentFields(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        List<IContract_MetaData__c> metadataList 							= new List<IContract_MetaData__c>();
        Map<String, List<IContract_MetaData__c>> dependentFieldsMap 		= new Map<String, List<IContract_MetaData__c>>();
        List<CreateContractWrapper.cls_customEntityList> customEntityList	= new List<CreateContractWrapper.cls_customEntityList>();
        
        metadataList														= CreateContractCtrlModel.getDependentMetadataList(type, subType);
        if(!metadataList.isEmpty()){
            dependentFieldsMap												= prepareDependentFieldMap(metadataList);
            for(String key : dependentFieldsMap.keySet()){
				CreateContractWrapper.cls_customEntityList customEntityListObj	= new CreateContractWrapper.cls_customEntityList();                
                customEntityListObj.customEntityName 							= key;
                List<CreateContractWrapper.cls_customField> customFieldList 	= new List<CreateContractWrapper.cls_customField>();
                for(IContract_MetaData__c metadataObj : dependentFieldsMap.get(key)){
                    CreateContractWrapper.cls_customField customFieldObj	= new CreateContractWrapper.cls_customField();
                    String value 	= '';
                    if(contractObj.get(metadataObj.Mapping_Field__c) != null)
                    value	= String.valueOf(contractObj.get(metadataObj.Mapping_Field__c));
                    if(apiAndValueMappingMap.containsKey(metadataObj.Field_Name__c)){
                        String newValue	= '';
                        for(Value_Mapping__c valueMappingObj : apiAndValueMappingMap.get(metadataObj.Field_Name__c)){
                            if(value == valueMappingObj.Mapping_Value__c){
                                newValue = valueMappingObj.IContract_Value__c;  
                                break;
                            }
                        }
                        value = newValue;
                    }
                    customFieldObj.fieldName	= metadataObj.Field_Name__c;
                    customFieldObj.fieldValue	= value;
                    customFieldList.add(customFieldObj);
                }
                CreateContractWrapper.cls_customFields customField 				= new CreateContractWrapper.cls_customFields();
                customField.customField 										= customFieldList;
                
                CreateContractWrapper.cls_customEntity custEntity 				= new CreateContractWrapper.cls_customEntity();
                custEntity.customFields 										= customField;
                
                CreateContractWrapper.cls_customEntityWrapper custEntityWrap 	= new CreateContractWrapper.cls_customEntityWrapper();
                custEntityWrap.customEntity 									= new List<CreateContractWrapper.cls_customEntity>{custEntity};
                    
                customEntityListObj.customEntityWrapper 								= custEntityWrap;    
                customEntityList.add(customEntityListObj);                
            }
            
            CreateContractWrapper.cls_customEntities custEntities 			= new CreateContractWrapper.cls_customEntities();
        	custEntities.customEntityList 									= customEntityList;
                    
            CreateContractWrapper.cls_contractDetails contDetails 			= wrapObj.contractDetails;
        	contDetails.customEntities										= custEntities;
            wrapObj.contractDetails											= contDetails;
        }
        return wrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapContractParties(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        Account accountObj 	= new Account();
        accountObj			= CreateContractCtrlModel.getAccountDetailsForContract(contractObj.AccountId);
		CreateContractWrapper.cls_contractingParties contractPartiesObj 			= new CreateContractWrapper.cls_contractingParties();
        CreateContractWrapper.cls_primaryContractingParty primaryContractPartyObj 	= new CreateContractWrapper.cls_primaryContractingParty();
        primaryContractPartyObj.primaryContractingPartyId							= accountObj.Contract_Party_ExternalId__c == null ? '' : String.valueOf(accountObj.Contract_Party_ExternalId__c);
        primaryContractPartyObj.primaryContractingPartyName							= accountObj.ContractParty_LegalName__c == null ? '' : String.valueOf(accountObj.ContractParty_LegalName__c);
        primaryContractPartyObj.contactPersonId										= '';
        contractPartiesObj.primaryContractingParty									= primaryContractPartyObj;	
        wrapObj.contractingParties													= contractPartiesObj;
        return wrapObj;
    }
    
    
    static CreateContractWrapper.cls_contract mapLineItems(CreateContractWrapper.cls_contract wrapObj, String type, String subType, Contract contractObj){
        List<OpportunityLineItem> oppLineItemsList 	= new List<OpportunityLineItem>();
        oppLineItemsList							= CreateContractCtrlModel.getLineItemsForContract(contractObj.Opportunity__c);
        if(!oppLineItemsList.isEmpty()){
            CreateContractWrapper.cls_lineItems lineItemsObj			= new CreateContractWrapper.cls_lineItems();
            List<CreateContractWrapper.cls_lineItem> lineItemsList		= new List<CreateContractWrapper.cls_lineItem>();
            for(OpportunityLineItem oppLineItemObj : oppLineItemsList){
                CreateContractWrapper.cls_lineItem lineItemObj			= new CreateContractWrapper.cls_lineItem();
                lineItemObj.itemNumber									= oppLineItemObj.ProductCode == null ? '' : String.valueOf(oppLineItemObj.ProductCode);
                lineItemObj.description									= oppLineItemObj.Description == null ? '' : String.valueOf(oppLineItemObj.Description);
                lineItemObj.quantity									= oppLineItemObj.Quantity == null ? '' : String.valueOf(oppLineItemObj.Quantity);
                lineItemObj.cost										= oppLineItemObj.UnitPrice == null ? '' : String.valueOf(oppLineItemObj.UnitPrice);
                lineItemObj.unitsOfMeasurement							= oppLineItemObj.Units_of_Measurement__c == null ? '' : String.valueOf(oppLineItemObj.Units_of_Measurement__c);
                lineItemObj.priceType									= oppLineItemObj.Price_Type__c == null ? '' : String.valueOf(oppLineItemObj.Price_Type__c);
                lineItemObj.ccurrency									= oppLineItemObj.Currency__c == null ? '' : String.valueOf(oppLineItemObj.Currency__c);
                lineItemsList.add(lineItemObj);
            }
            lineItemsObj.lineItem										= lineItemsList;
            wrapObj.lineItems 											= lineItemsObj;
        }
        return wrapObj;
    }
    
    
    static void prepareContractMaps(List<Create_Contract_API_Mapping__mdt> createContractMappingCMList){
        for(Create_Contract_API_Mapping__mdt mappingObj : createContractMappingCMList){
            if(mappingObj.Type__c == 'Contract'){
                contractMap.put(mappingObj.Id, mappingObj);
            }
            if(mappingObj.Type__c == 'Contract Headers'){
                contractHeaderMap.put(mappingObj.Id, mappingObj);
            }
            if(String.isNotBlank(mappingObj.Mapping_Contract_Field__c)){
                standardMappedFieldsSet.add(mappingObj.Mapping_Contract_Field__c);
            }
        }
    }
    
    
    static Map<String, String> prepareApiAndContractFieldNameMap(List<IContract_MetaData__c> metadataList){
        Map<String, String> apiAndContractFieldNameMap		= new Map<String, String>();
        apiAndValueMappingMap								= new Map<String, List<Value_Mapping__c>>();
        for(IContract_MetaData__c metadataObj : metadataList){
            apiAndContractFieldNameMap.put(metadataObj.Field_Name__c, metadataObj.Mapping_Field__c);
            if(!metadataObj.Value_Mappings__r.isEmpty()){
                apiAndValueMappingMap.put(metadataObj.Field_Name__c, metadataObj.Value_Mappings__r);
            }
        }
        return apiAndContractFieldNameMap;
    }
    
    
    static Map<String, List<IContract_MetaData__c>> prepareDependentFieldMap(List<IContract_MetaData__c> metadataList){
        Map<String, List<IContract_MetaData__c>> dependentFieldsMap 	= new Map<String, List<IContract_MetaData__c>>();
        apiAndValueMappingMap											= new Map<String, List<Value_Mapping__c>>();
       
        for(IContract_MetaData__c metadataObj : metadataList){
            if(dependentFieldsMap.containsKey(metadataObj.Dependant_Fields__c))
                dependentFieldsMap.get(metadataObj.Dependant_Fields__c).add(metadataObj);
            else
                dependentFieldsMap.put(metadataObj.Dependant_Fields__c, new List<IContract_MetaData__c>{metadataObj});
            if(!metadataObj.Value_Mappings__r.isEmpty()){
                apiAndValueMappingMap.put(metadataObj.Field_Name__c, metadataObj.Value_Mappings__r);
            }
        }
        return dependentFieldsMap;
    }
}