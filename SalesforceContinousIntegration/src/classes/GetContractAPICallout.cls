public class GetContractAPICallout {

    //@future (callout=true)
    public static List<GetContractDetailsWrapper.cls_metaDataField> getContractAPIcalloutToZycus(String ContractNumber){
        Http http 							= new Http();
        HttpRequest request 				= new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/contract/'+ContractNumber);
        request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
        request.setHeader('x-zycus-integrationTrackingNumber', '22');
        request.setTimeout(60000);
        HttpResponse response = http.send(request);
        GetContractDetailsWrapper resp 	= GetContractDetailsWrapper.parse(response.getBody());
        
        List<GetContractDetailsWrapper.cls_metaDataField> metaDataFieldsDetails = new List<GetContractDetailsWrapper.cls_metaDataField>();
        metaDataFieldsDetails = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractDetails.metaDataFields.metaDataField;
        
        system.debug(resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractDetails.metaDataFields.metaDataField);
        system.debug(metaDataFieldsDetails);
        
        
        return metaDataFieldsDetails;
    }
}