public class Constants {

    //Recordtype Names
    public static final String TYPE_SUBTYPE_RT      				= System.Label.Type_Subtype_Mapping_RecordType;
    public static final String CONTRACT_MAPPING_RT  				= System.Label.Contract_Mapping_RecordType;
    
    //Object API Names
    public static final String MAPPING_CONFIG_OBJ   				= 'Mapping_Configurations__c';

    //Picklist Values
    public static final String MAPPING_CONFIG_ACTIVE_STATUS 		= System.Label.Mapping_Status_Active;
    public static final String MAPPING_CONFIG_INACTIVE_STATUS 		= System.Label.Mapping_Status_Inactive;
    
    
    public static final String FUNCTION_TYPE_GET_CONTRACT_PE 		= System.Label.Function_Type_Get_Contract_PE;
    public static final String Function_Type_CREATE_CONTRACT_SF 	= System.Label.Function_Type_Create_Contract_SF;

	public static final String PAYLOAD_STATUS_FAILURE 				= 'Failure';
    public static final String PAYLOAD_STATUS_SUCCESS 				= 'Success';
    	
    public static final String STAGE1_MAP_CONFIG 					= 'Step 1';
    public static final String STAGE2_MAP_CONFIG 					= 'Step 2';
    public static final String STAGE3_MAP_CONFIG 					= 'Step 3';
    public static final String STAGE4_MAP_CONFIG 					= 'Step 4';
    public static final String STAGE5_MAP_CONFIG 					= 'Step 5';
    
    // Constants used In Content Version(attaching file to PDF)
    public static final String CONTENT_LOCATION						= 'S'; 
    public static final String CONTENT_ORIGIN						= 'H';
    public static final String CONTENT_SHARE_TYPE					= 'I';
    
    public static final String maxApiCalloutCount					= system.label.maxApiCalloutCount;
    public static final String Failure_Status      					= system.label.Failure_Status;
    
    public static final String SOT_SALESFORCE						= 'Salesforce';
    
    public static final String NON_EDITED_CONTRACT_STATUSES 		= System.Label.Contract_Status_Contract_not_to_be_Updated;
    public static final String Mappingcong_status                   = System.label.Mappingcong_status;
    public static final String icontract_SOT                        = System.label.icontract_SOT;
    
    //for contract owner api criteria
    public static final String CO_ContractType_criteria 			= System.label.CO_ContractType_criteria;
    public static final String CO_ContractType_criteria_operation 	= System.label.CO_ContractType_criteria_operation;
    public static final String CO_ContractType_criteria_2peration 	= System.label.CO_ContractType_criteria_2peration;
    public static final String CO_fetch_Number					 	= System.label.CO_fetch_Number;
    public static final String CO_IntegrationTracking_Num		 	= System.label.CO_IntegrationTracking_Num;
    
    //for contract party api criteria
    public static final string unable_to_fetch_contract_party_error_message = system.label.unable_to_fetch_contract_party_error_message;
    public static final string CP_ContractType_criteria					    = system.label.CP_ContractType_criteria;
    public static final string CP_ContractType_criteria_operation			= system.label.CP_ContractType_criteria_operation;
    public static final string CP_ContractType_criteria2					= system.label.CP_ContractType_criteria2;
    public static final string CP_ContractType_criteria_operation2			= system.label.CP_ContractType_criteria_operation2;
    public static final string CP_fetch_Number								= system.label.CP_fetch_Number;
    public static final string CP_search_condition_for_req					= system.label.CP_search_condition_for_req;
    public static final string CP_integrationTrackingNumber					= system.label.CP_integrationTrackingNumber;
    
    
    //
    public static final string SFDC_icontract_status       					= system.label.SFDC_icontract_status;
    
    //API Metadata details
    public static final string StandardTemplate          					= system.label.StandardTemplate;
    public static final string ContractParty             					= system.label.ContractParty;
    public static final string ContractOwner             					= system.label.ContractOwner;

}