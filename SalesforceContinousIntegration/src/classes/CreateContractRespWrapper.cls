public class CreateContractRespWrapper{
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
		public String referenceCodeForEntity;	//AUTO10023
	}
    
	
    public class cls_integrationEntityDetails {
		public cls_acknowledgement acknowledgement;
	}
    
    
	public class cls_acknowledgement {
		public String id;	//ff8080816541acc7016542566fcf0018
		public String externalId;	//ICONTRACT_SYSTEM_TEST_EXTERNAL_ID
		public String status;	//SUCCESS
	}
    
    
	public static CreateContractRespWrapper parse(String json){
		return (CreateContractRespWrapper) System.JSON.deserialize(json, CreateContractRespWrapper.class);
	}

}