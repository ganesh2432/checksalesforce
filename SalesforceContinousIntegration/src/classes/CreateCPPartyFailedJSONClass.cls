/*----------------------------------------------------------------------------
 * Description :   This controller to query data from DB.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   20/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public class CreateCPPartyFailedJSONClass {
	public cls_IntegrationEntities IntegrationEntities;
	public class cls_IntegrationEntities {
		public cls_integrationEntity[] integrationEntity;
	}
	public class cls_integrationEntity {
		public cls_integrationEntityHeader integrationEntityHeader;
		public cls_integrationEntityDetails integrationEntityDetails;
		public cls_processingErrors processingErrors;
	}
	public class cls_integrationEntityHeader {
		public String integrationTrackingNumber;	
		public String referenceCodeForEntity;	
	}
	public class cls_integrationEntityDetails {
		public cls_acknowledgement acknowledgement;
	}
	public class cls_acknowledgement {
		public String id;	
		public String externalId;	
		public String status;	
	}
	public class cls_processingErrors {
		public boolean shouldRetry;
		public cls_error[] error;
	}
	public class cls_error {
		public String errorCode;	
		public String errorDescription;
	}
	public static CreateCPPartyFailedJSONClass parse(String json){
		return (CreateCPPartyFailedJSONClass) System.JSON.deserialize(json, CreateCPPartyFailedJSONClass.class);
	}
}