public class ContractPartyRequest {

	public cls_IntegrationEntities IntegrationEntities;
	public class cls_IntegrationEntities {
		public cls_integrationEntity[] integrationEntity;
	}
	public class cls_integrationEntity {
		public cls_integrationEntityHeader integrationEntityHeader;
		public cls_integrationEntityDetails integrationEntityDetails;
	}
	public class cls_integrationEntityHeader {
		public String integrationTrackingNumber;	//INTEGRATIONTRACKINGNUMBER
		public String referenceCodeForEntity;	//
	}
	public class cls_integrationEntityDetails {
		public cls_search search;
	}
	public class cls_search {
		public String type;	//AND
		public cls_pagination pagination;
		public cls_criterias criterias;
	}
	public class cls_pagination {
		public String currentPage;	//1
		public String perPage;	//100
	}
	public class cls_criterias {
		public cls_criteria[] criteria;
	}
	public class cls_criteria {
		public String fieldName;	//CONTRACTING_PARTY
		public String operation;	//CONTAINS
		public String value;	//SALESFORCE_SUPPLIER_1
		public String minValue;	//
		public String maxValue;	//
	}
	public static ContractPartyRequest parse(String json){
		return (ContractPartyRequest) System.JSON.deserialize(json, ContractPartyRequest.class);
	}
}