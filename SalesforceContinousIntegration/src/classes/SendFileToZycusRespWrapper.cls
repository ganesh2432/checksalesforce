public class SendFileToZycusRespWrapper {
    
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
        public String integrationTrackingNumber;	//213124
        public String referenceCodeForEntity;	//attachment
    }
    
    public class cls_integrationEntityDetails {
        public cls_attachment attachment;
        public cls_acknowledgement acknowledgement;
    }
    
    public class cls_acknowledgement {
		public String id;	//
		public String externalId;	//
		public String status;	//FAILED
	}
    
    public class cls_error {
		public String errorCode;	//NR-ICOT-C-1028
		public String errorDescription;	//Invalid file extension.
	}
    
    public class cls_processingErrors {
		public boolean shouldRetry;
		public cls_error[] error;
	}
    
    public class cls_attachment {
        public String id;	//8a8a8aeb65c4385e0165e65a84e90046
    }
    
    
    public static SendFileToZycusRespWrapper parse(String json){
        return (SendFileToZycusRespWrapper) System.JSON.deserialize(json, SendFileToZycusRespWrapper.class);
    }
    /*
static testMethod void testParse() {
String json=		'{'+
'    "IntegrationEntities": {'+
'        "integrationEntity": ['+
'            {'+
'                "integrationEntityHeader": {'+
'                    "integrationTrackingNumber": "213124",'+
'                    "referenceCodeForEntity": "attachment"'+
'                },'+
'                "integrationEntityDetails": {'+
'                    "attachment": {'+
'                        "id": "8a8a8aeb65c4385e0165e65a84e90046"'+
'                    }'+
'                }'+
'            }'+
'        ]'+
'    }'+
'}';
fromJSON obj = parse(json);
System.assert(obj != null);
}
*/
}