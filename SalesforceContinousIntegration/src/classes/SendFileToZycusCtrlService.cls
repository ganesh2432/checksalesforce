public class SendFileToZycusCtrlService {

	public static void callFileUploadAPI(String fileId, String refDocId){
		ContentVersion fileObj = new ContentVersion(); 
		fileObj				   = SendFileToZycusCtrlModel.getFileDetails(fileId);
		callUploadAPI(fileObj.PathOnClient, fileObj.VersionData, fileObj.FileExtension, refDocId);
	}


	public static void callUploadAPI(String fileName, Blob fileBody, String fileType, String refDocId){
		Create_Contract_Params__c paramObj   = Create_Contract_Params__c.getOrgDefaults();
		String boundary = '----WebKitFormBoundaryTest7MA4YWxkTrZu0gW';
        String footer = '--' + boundary + '--';
                
        String body = '--' + boundary + '\r\nContent-Disposition: form-data; name=\"request\";filename=\"'+fileName+'\"\r\nContent-Type:'+fileType+'\r\n\r\n';
		String headerBody = EncodingUtil.base64Encode(Blob.valueOf(body));
		String bodyEncoded = EncodingUtil.base64Encode(fileBody);
		String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		body = body+bodyEncoded+'\r\n'+footer;
		HttpRequest req = new HttpRequest();
		req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
		req.setHeader('x-zycus-tenantId', paramObj.Tenant_Id__c);
        req.setHeader('x-zycus-integrationTrackingNumber', paramObj.Tracking_Number__c);
		req.setMethod('POST');
		req.setEndpoint(paramObj.File_Upload_URL__c);
		req.setBodyasBlob(Blob.valueOf(body));
		req.setTimeout(120000);
		Http http = new Http();
		HTTPResponse res = http.send(req);
        Reference_Documents__c refDocObj 	= new Reference_Documents__c(Id = refDocId);
        if(res.getStatusCode() == 200){
            SendFileToZycusRespWrapper respWrapObj = SendFileToZycusRespWrapper.parse(res.getBody());
            if(respWrapObj.IntegrationEntities.integrationEntity[0].processingErrors != null){
                String errMsg 							= respWrapObj.IntegrationEntities.integrationEntity[0].processingErrors.error[0].errorDescription;
                refDocObj.File_Uploaded__c 				= false;
                refDocObj.File_Upload_Error_Message__c	= res.getBody();
            }else{
                refDocObj.File_Uploaded__c 				= true;
                refDocObj.File_Upload_Error_Message__c	= null;
                refDocObj.Zycus_File_Id__c 				= respWrapObj.IntegrationEntities.integrationEntity[0].integrationEntityDetails.attachment.id;
            }
        }else{
            refDocObj.File_Uploaded__c 					= false;
            refDocObj.File_Upload_Error_Message__c		= res.getBody();
        }
        update refDocObj;
        system.debug('res::::'+res);
        system.debug('res::::'+res.getBody());
	}
}