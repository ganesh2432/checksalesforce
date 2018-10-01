public class GetContractDetailsWrapper {

	public cls_IntegrationEntities IntegrationEntities;
	public class cls_IntegrationEntities {
		public cls_integrationEntity[] integrationEntity;
	}
	public class cls_integrationEntity {
		public cls_integrationEntityHeader integrationEntityHeader;
		public cls_integrationEntityDetails integrationEntityDetails;
	}
	public class cls_integrationEntityHeader {
		public String integrationTrackingNumber;	//22
		public String referenceCodeForEntity;	//AUTO10024
        public cls_attachments attachments;
	}
    
    public class cls_attachments {
		public cls_attachment[] attachment;
	}
	public class cls_attachment {
		public String id;	//1533298060852
		public String name;	//Contract without audits 4.docx
		public String size;	//9048
	}
    
	public class cls_integrationEntityDetails {
		public cls_contract contract;
	}
	public class cls_contract {
		public String contractId;	//ff8080816541acc70165425a661c0023
		public String externalId;	//ICONTRACT_SYSTEM_TEST_EXTERNAL_ID
		public String isAmendment;	//No
		public String createdOn;	//2018-08-16
		public String updatedOn;	//2018-08-16
		public String byPassAuthoringReview;	//NO
		public String byPassNegotiateCycle;	//NO
		public String contractSource;	//External System
		public String contractModule;	//Authoring
		//public cls_contractHeaders contractHeaders;
		public Map<String,String> contractHeaders;
		public cls_contractDetails contractDetails;
		public cls_amendmentDetails amendmentDetails;
		public cls_businessUnits businessUnits;
		public cls_contractOutline contractOutline;
		public cls_lineItems lineItems;
		public cls_contractingParties contractingParties;
		public cls_amendments amendments;
		public cls_utilization utilization;
		public cls_alertsReminders alertsReminders;
	}
	/*public class cls_contractHeaders {
		public String type;	//Facilities Agreement
		public String subType;	//Services
		public String status;	//Draft in Progress
		public String contractNumber;	//AUTO10024
		public String contractTitle;	//Contract without audits 4
		public String contractOwner;	//azaj.shaikh@zycus.com
		public String hierarchyStatus;	//
		public String folder;	//
		public String region;	//Global
		public String contractCategory;	//Advertising
		public String contractScannedCopy;	//
		public String contractAuthoringCopy;	//
		public String contractStartDate;	//2017-06-01
		public String autoRenew;	//No
		public String contractExpirationDate;	//2019-06-01
		public String contractRenewalDate;	//
		public String contractValue;	//450003456334.00
		public String baseCurrency;	//AED
	}*/
	public class cls_contractDetails {
		public cls_metaDataFields metaDataFields;
		public cls_customEntities customEntities;
	}
	public class cls_metaDataFields {
		public cls_metaDataField[] metaDataField;
	}
	public class cls_metaDataField {
		public String fieldName;	//IS_ARCHIVED
		public String fieldValue;	//0
	}
	public class cls_customEntities {
	}
	public class cls_amendmentDetails {
		public String amendmentNo;	//
		public String amendmentEffectiveDate;	//
		public String amendmentDescription;	//
	}
	public class cls_businessUnits {
	}
	public class cls_contractOutline {
		public String templateType;	//EXTERNAL
	}
	public class cls_lineItems {
		public cls_lineItem[] lineItem;
	}
	public class cls_lineItem {
		public String itemNumber;	//G318225
		public String description;	//BOM for Semiconductor Devices
		public String unitsOfMeasurement;	//Each
		public String quantity;	//75.00
		public String category;	//32111700
		public String priceType;	//Bulk
		//public String currency;	//AED
		public String cost;	//7.50
		public cls_pricingType pricingType;
		public cls_customFields customFields;
	}
	public class cls_pricingType {
		public String type;	//Volume Based Discount Pricing
		public cls_volumeBasedDiscountSlabs volumeBasedDiscountSlabs;
	}
	public class cls_volumeBasedDiscountSlabs {
		public cls_volumeBasedDiscountSlab[] volumeBasedDiscountSlab;
	}
	public class cls_volumeBasedDiscountSlab {
		public String lowerLimitQuantity;	//0.01
		public String upperLimitQuantity;	//15.00
		public String basePrice;	//80.00
		public String discount;	//2.50
	}
	public class cls_customFields {
	}
	public class cls_contractingParties {
		public cls_primaryContractingParty primaryContractingParty;
		public cls_otherContractingParties otherContractingParties;
	}
	public class cls_primaryContractingParty {
		public String primaryContractingPartyId;	//862626
		public String primaryContractingPartyName;	//SALESFORCE_SUPPLIER_1
		public String contactPersonId;	//1245998
	}
	public class cls_otherContractingParties {
	}
	public class cls_amendments {
		public cls_amendmentId[] amendmentId;
	}
	public class cls_amendmentId {
	}
	public class cls_utilization {
		public String utilizationAmount;	//0.0
		public String percentUtilization;	//0.0
	}
	public class cls_alertsReminders {
	}
	public static GetContractDetailsWrapper parse(String json){
		return (GetContractDetailsWrapper) System.JSON.deserialize(json, GetContractDetailsWrapper.class);
	}

   
}