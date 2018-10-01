/*----------------------------------------------------------------------------
 * Description :   This controller to query data from DB.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   20/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public class CreateCPPartySuccessJSONClass {
	public cls_IntegrationEntities IntegrationEntities;
	public class cls_IntegrationEntities {
		public cls_integrationEntity[] integrationEntity;
	}
    public class cls_integrationEntity {
		public cls_integrationEntityHeader integrationEntityHeader;
		public cls_integrationEntityDetails integrationEntityDetails;
	}
	public class cls_integrationEntityHeader {
		public String integrationTrackingNumber;	
		public String referenceCodeForEntity;	
	}
	public class cls_integrationEntityDetails {
		public String id;	
		public String externalId;	
		public String status;	
		public cls_addresses addresses;
	}
	public class cls_addresses {
		public cls_addressDetails[] addressDetails;
	}
	public class cls_addressDetails {
		public Integer addressId;	
		public cls_contacts contacts;
	}
	public class cls_contacts {
		public cls_contactDetails[] contactDetails;
	}
	public class cls_contactDetails {
		public Integer contactId;	
		public String emailId;	
	}
	public static CreateCPPartySuccessJSONClass parse(String json){
		return (CreateCPPartySuccessJSONClass) System.JSON.deserialize(json, CreateCPPartySuccessJSONClass.class);
	}
}