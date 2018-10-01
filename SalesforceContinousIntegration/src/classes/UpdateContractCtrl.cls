public class UpdateContractCtrl {
	public static String createReqJSON(String cId, Contract contractSObj){
        Contract cObj 	= new Contract();
        if(String.isBlank(cId)) cObj	= contractSObj;
        else{
            String query 	= Utility.getDynamQuery('Contract', 'Id =: cId');  
            cObj 			= Database.query(query);   
        }
        CreateContractWrapper.cls_attachments attachment 	= new CreateContractWrapper.cls_attachments();
        CreateContractWrapper.cls_integrationEntityHeader integrationHeader 	= new CreateContractWrapper.cls_integrationEntityHeader();
        integrationHeader.integrationTrackingNumber = 'INTEGRATIONTRACKINGNUMBER';
        integrationHeader.referenceCodeForEntity = '';
        attachment.attachment 	= new List<CreateContractWrapper.cls_attachment>();
        integrationHeader.attachments = attachment;
        
        CreateContractWrapper.cls_amendmentDetails amendDetails 		= new CreateContractWrapper.cls_amendmentDetails();
        CreateContractWrapper.cls_amendments amends 				= new CreateContractWrapper.cls_amendments();
        amends.amendmentId 											= new List<CreateContractWrapper.cls_amendmentId>();
        CreateContractWrapper.cls_utilization utilization 			= new CreateContractWrapper.cls_utilization();
        CreateContractWrapper.cls_contract contractObj 	= new CreateContractWrapper.cls_contract();
        contractObj.amendmentDetails 	= amendDetails;
        contractObj.amendments  		= amends;
        contractObj.utilization  		= utilization;
        contractObj						= UpdateContractCtrlService.mapFields(contractObj, cObj.Type__c, cObj.SubType__c, cObj);
        
        CreateContractWrapper.cls_integrationEntityDetails intEntityDet 	= new CreateContractWrapper.cls_integrationEntityDetails();
        intEntityDet.contract	= contractObj;
        
        CreateContractWrapper.cls_integrationEntity integrationEntity = new CreateContractWrapper.cls_integrationEntity();
        integrationEntity.integrationEntityHeader	= integrationHeader;
        integrationEntity.integrationEntityDetails	= intEntityDet;
        CreateContractWrapper.cls_IntegrationEntities integrationEntities = new CreateContractWrapper.cls_IntegrationEntities();
        integrationEntities.integrationEntity 	= new List<CreateContractWrapper.cls_integrationEntity>{integrationEntity};
        CreateContractWrapper contractWrap 		= new CreateContractWrapper();
        contractWrap.IntegrationEntities 		= integrationEntities;
        String res 								= JSON.serialize(contractWrap);
        res										= res.replace('ccurrency', 'currency');
        system.debug('res:::::'+res);
        return res;
    }
}