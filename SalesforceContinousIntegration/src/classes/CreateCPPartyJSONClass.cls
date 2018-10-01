/*----------------------------------------------------------------------------
 * Description :   This controller to prepars JSON structure for create CP
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   15/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public class CreateCPPartyJSONClass {
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
		public cls_contractingParty contractingParty;
	}
	public class cls_contractingParty {
		public String legalName;	
		public String externalId;
		public cls_addresses addresses;
	}
	public class cls_addresses {
		public cls_addressDetails[] addressDetails;
	}
	public class cls_addressDetails {
		public cls_contacts contacts;
	}
	public class cls_contacts {
		public cls_contactDetails[] contactDetails;
	}
	public class cls_contactDetails {
		public String firstName;	
		public String lastName;	
		public String email;	
		public String phone;	
	}
	public static CreateCPPartyJSONClass parse(String json){
		return (CreateCPPartyJSONClass) System.JSON.deserialize(json, CreateCPPartyJSONClass.class);
	}
}