public class UpdateContractAPICtrlService {
	
	public static CreateContractRespWrapper callUpdateContract(String contractId, Contract contractSObj){
        String payLoadId 	= null;
        Decimal callCount	= 0;
        Create_Contract_Params__c paramObj 	= Create_Contract_Params__c.getOrgDefaults();
        List<PayLoad__c> payLoadList		= new List<PayLoad__c>();
        payLoadList							= CreateContractAPICtrlModel.getPayLoadRecord(contractId, Constants.Function_Type_CREATE_CONTRACT_SF);
        if(payLoadList.size() > 0) {
            payLoadId 	= payLoadList[0].Id;
            callCount	= payLoadList[0].CalloutCount__c;
        }
        
        Http http 							= new Http();
        HttpRequest request 				= new HttpRequest();
        HttpResponse response;
        try{
            request.setMethod('POST');
            request.setEndpoint(paramObj.Update_API_Endpoint__c);
            request.setHeader('x-zycus-tenantId', paramObj.Tenant_Id__c);
            request.setHeader('x-zycus-integrationTrackingNumber', paramObj.Tracking_Number__c);
            request.setHeader('Content-Type', paramObj.Content_Type__c);
            request.setHeader('x-zycus-username', paramObj.Username__c);
            request.setBody(UpdateContractCtrl.createReqJSON(contractId, contractSObj));
            response = http.send(request);
            CreateContractRespWrapper resp 	= CreateContractRespWrapper.parse(response.getBody());
            Contract contractObj 			= new Contract(Id = contractId, 
            											   IContract_Id__c = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.acknowledgement.id,
            											   Last_Updated_Date_IContract__c = System.now(),
                                                           Update_from_Opportunity__c = false,
                                                           Icontract_update_Error_Message_SF_to_IC__c = null);

            update contractObj;
            Utility.createPayLoadRecord(request.getBody(), response.getBody(), 0, contractId, null, null, null, Constants.PAYLOAD_STATUS_SUCCESS, Constants.Function_Type_CREATE_CONTRACT_SF, null, payLoadId);
            return resp;    
        }catch(Exception e){
            Contract contractObj 			= new Contract(Id = contractId, 
                                                           Icontract_update_Error_Message_SF_to_IC__c = e.getMessage() + ' \n Stack Trace :' + e.getStackTraceString()+ ' \n Line Number'+ String.valueOf(e.getLineNumber()));
            update contractObj;
            Utility.createPayLoadRecord(request.getBody(), response.getBody(),callCount + 1, contractId, null, null, null, Constants.PAYLOAD_STATUS_FAILURE, Constants.Function_Type_CREATE_CONTRACT_SF, e.getMessage() + ' \n Stack Trace :' + e.getStackTraceString()+ ' \n Line Number'+ String.valueOf(e.getLineNumber()), payLoadId);
        }
        return null;
    }
}