public class CreateContractWrapper {

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
		public cls_attachments attachments;
	}
    
	public class cls_attachments {
		public cls_attachment[] attachment;
	}
    
	public class cls_attachment {
	}
    
    public class cls_integrationEntityDetails {
		public cls_contract contract;
	}
    
	public class cls_contract {
        public Map<String, String> contractHeaders ;
		public String contractId;	//4028861d60c0c23e0160d491f9040071
		public String externalId;	//ICONTRACT_SYSTEM_TEST_EXTERNAL_ID
		public String isAmendment;	//No
		public String createdOn;	//2017-03-27
		public String updatedOn;	//2017-04-25
		public String byPassNegotiateCycle;	//Yes
		public String byPassAuthoringReview;	//No
		public String contractModule;	//Authoring
		public cls_contractOutline contractOutline;
        public cls_contractDetails contractDetails;
        public cls_amendmentDetails amendmentDetails;
        public cls_businessUnits businessUnits;
		public cls_contractingParties contractingParties;
        public cls_lineItems lineItems;
        public cls_amendments amendments;
        public cls_utilization utilization;
    }

    public class cls_contractOutline {
		public String templateType;	//EXTERNAL
		public String externalFileId;	//1514516235744
	}
    
    public class cls_contractDetails {
		public cls_metaDataFields metaDataFields;
		public cls_customEntities customEntities;
	}
	
    public class cls_metaDataFields {
		public cls_metaDataField[] metaDataField;
	}
    
	public class cls_metaDataField {
		public String fieldName;	//Terms
		public String fieldValue;	//Active
	}
    
    public class cls_customEntities {
		public cls_customEntityList[] customEntityList;
	}
    
	public class cls_customEntityList {
		public String customEntityName;	//FinancialObligations
		public cls_customEntityWrapper customEntityWrapper;
	}
    
	public class cls_customEntityWrapper {
		public cls_customEntity[] customEntity;
	}
    
	public class cls_customEntity {
		public cls_customFields customFields;
	}
    
	public class cls_customFields {
		public cls_customField[] customField;
	}
    
	public class cls_customField {
		public String fieldName;	//Financial_Obligations
		public String fieldValue;	//123
	}
    
    public class cls_amendmentDetails {
		public String amendmentNo;	//123
		public String amendmentEffectiveDate;	//2020-05-31
	}

	public class cls_businessUnits {
		public cls_businessUnit[] businessUnit;
	}

	public class cls_businessUnit {
	}
    
	public class cls_contractingParties {
		public cls_primaryContractingParty primaryContractingParty;
		public cls_otherContractingParties otherContractingParties;
	}
    
	public class cls_primaryContractingParty {
		public String primaryContractingPartyId;	//842708
		public String primaryContractingPartyName;	//
		public String contactPersonId;	//
	}
    
	public class cls_otherContractingParties {
		public cls_otherContractingParty[] otherContractingParty;
	}
    
	public class cls_otherContractingParty {
		public String contractingPartyId;	//
		public String isDelete;	//no
		public String contractingPartyName;	//
		public String contactPersonId;	//
	}
    
    public class cls_amendments {
		public cls_amendmentId[] amendmentId;
	}
    
	public class cls_amendmentId {
	}
    
    public class cls_utilization {
		public String utilizationAmount;	//400
		public String percentUtilization;	//7
		public cls_poDetails poDetails;
	}
    
	public class cls_poDetails {
		public cls_poInformation[] poInformation;
	}
    
	public class cls_poInformation {
		public String poQuantity;	//
		public String poNumber;	//P734
		public String poDate;	//2017-08-01
		public String poUnitPrice;	//55673
		public String vendorId;	//9234
		public String poDescription;	//
	}
    
    public class cls_lineItems {
		public cls_lineItem[] lineItem;
	}
    
	public class cls_lineItem {
		public String itemNumber;	//G318225
		public String description;	//BOM for Semiconductor Devices
		public String unitsOfMeasurement;	//Each
		public String quantity;	//75
		public String category;	//32111700
		public String priceType;	//Bulk
		public String ccurrency;	//AUD
		public String cost;	//7.5
	//	public cls_pricingType pricingType;
	}
    
	public class cls_pricingType {
		public String type;	//Volume Based Discount Pricing
		public String fixedPrice;	//7.5
		public cls_volumeBasedPriceSlabs volumeBasedPriceSlabs;
		public cls_volumeBasedDiscountSlabs volumeBasedDiscountSlabs;
	}
    
	public class cls_volumeBasedPriceSlabs {
		public cls_volumeBasedPriceSlab[] volumeBasedPriceSlab;
	}
    
	public class cls_volumeBasedPriceSlab {
		public String lowerLimitQuantity;	//0
		public String upperLimitQuantity;	//500
		public String applicablePrice;	//7.5
	}
    
	public class cls_volumeBasedDiscountSlabs {
		public cls_volumeBasedDiscountSlab[] volumeBasedDiscountSlab;
	}
    
	public class cls_volumeBasedDiscountSlab {
		public String lowerLimitQuantity;	//0.01
		public String upperLimitQuantity;	//15
		public String basePrice;	//80
		public String discount;	//2.5
	}

    public static CreateContractWrapper parse(String json){
		return (CreateContractWrapper) System.JSON.deserialize(json, CreateContractWrapper.class);
	}

}