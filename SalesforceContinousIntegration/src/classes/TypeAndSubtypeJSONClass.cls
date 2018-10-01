/*----------------------------------------------------------------------------
 * Description :   This controller to prepare JSON structure.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   03/05/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class TypeAndSubtypeJSONClass {
    
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
		public cls_contractTypes contractTypes;
	}
	public class cls_contractTypes {
		public cls_types types;
	}
	public class cls_types {
		public cls_type[] type;
	}
	public class cls_type {
		public String baseTypeName;	
		public String typeName;	
		public String displayName;	
		public cls_subTypes subTypes;
	}
	public class cls_subTypes {
		public cls_subType[] subType;
	}
	public class cls_subType {
		public String subTypeName;	
		public String displayName;	
	}
	public static TypeAndSubtypeJSONClass parse(String json){
		return (TypeAndSubtypeJSONClass) System.JSON.deserialize(json, TypeAndSubtypeJSONClass.class);
	}
}