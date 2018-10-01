public class SalesforceFileUpload {
    
    public static void callOut(){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    String endpoint='https://rmicontract-jwb.zycus.com/iContract/endpoint/api/downloadAttachment?entityId=test&attachmentId=1533298107228';
    request.setEndpoint(endpoint);
    request.setHeader('x-zycus-tenantId','4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
    request.setHeader('x-zycus-integrationTrackingNumber','12345');
    request.setMethod('GET');
    HttpResponse response=http.send(request);   
    System.debug('Response:'+response);
	}
    public static void execute(){
        callOut();
    }
}