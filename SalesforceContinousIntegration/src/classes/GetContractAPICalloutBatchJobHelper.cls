public class GetContractAPICalloutBatchJobHelper {

        public static void calloutToGetcontractData(String evntContrctnumber,String EntityType,String EventDescription,String eventType){
        String requesturl = '';
        String responsebdy = '';
        try{
            
            List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycus = new List<GetContractDetailsWrapper.cls_metaDataField>();
            List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycusContrctHeaders = new List<GetContractDetailsWrapper.cls_metaDataField>();
            
            List<GetContractDetailsWrapper.cls_attachment> metadataAttachmentList = new List<GetContractDetailsWrapper.cls_attachment>();
            
            
            Http http 							= new Http();
            HttpRequest request 				= new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/contract/'+evntContrctnumber);
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '22');
            request.setTimeout(60000);
            HttpResponse response = http.send(request);
            requesturl = request.getEndpoint();
            responsebdy = response.getBody();
            GetContractDetailsWrapper resp 	= GetContractDetailsWrapper.parse(response.getBody());
            
            metaDatafieldDetailsFromZycus = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractDetails.metaDataFields.metaDataField;
            metadataAttachmentList = resp.IntegrationEntities.integrationEntity[0].integrationEntityHeader.attachments.attachment;
            
            
            Map<String,String> headerValues = new Map<String,String>();
            headerValues = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractHeaders;
            metaDatafieldDetailsFromZycusContrctHeaders = IcontractGetContractPltfrmEvntHelper.createcontractHeaders(headerValues);
            
            metaDatafieldDetailsFromZycus.addall(metaDatafieldDetailsFromZycusContrctHeaders);
                        
            //if(response.getStatusCode()>=200 && response.getStatusCode()<=204){
             system.debug(metaDatafieldDetailsFromZycus);
             IcontractGetContractPltfrmEvntHelper.updatecontractfrmpltEvnt(metaDatafieldDetailsFromZycus,evntContrctnumber,EntityType,EventDescription,eventType,requesturl,responsebdy,metadataAttachmentList);   
            //}else{
            //    insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Failure');
            //}
            
            
            
        }Catch(Exception e){
            HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'getcontractpltfrmEvnt', e);
            IcontractGetContractPltfrmEvntHelper.insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Failure',requesturl,responsebdy);
            IcontractGetContractPltfrmEvntHelper.updatefailurestatusincontractObj(evntContrctnumber,responsebdy);
        }
    }
}