public class ContractOwnerRequest {
    
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
		public cls_pagination pagination;
		//public cls_sorts sorts;
		public cls_criterias criterias;
	}
	public class cls_pagination {
		public String currentPage;	//1
		public String perPage;	//25
	}
	//public class cls_sorts {
	//}
	public class cls_criterias {
		public cls_criteria[] criteria;
	}
	public class cls_criteria {
		public String fieldName;	//CONTRACT_TYPE
		public String value;	//PURCHASEAGREEMENT
		public String operation;	//EQUALS
		public String minValue;	//
		public String maxValue;	//
	}
	public static ContractOwnerRequest parse(String json){
		return (ContractOwnerRequest) System.JSON.deserialize(json, ContractOwnerRequest.class);
	}

}