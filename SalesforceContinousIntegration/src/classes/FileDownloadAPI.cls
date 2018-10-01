public class FileDownloadAPI {  
    @future(callout=true)
    public static void downloadMethod(){
        Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/downloadAttachment?entityId=test&attachmentId=1535108269189');
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '12345');
            HttpResponse response = http.send(request);
            //Process response
            //String finalResponse = response.getBody();
            ContentVersion cv = new contentVersion();
            cv.ContentLocation = 'S';       
            cv.VersionData = response.getBodyAsBlob();
            cv.Title = 'Test2134.doc';
            cv.PathOnClient = 'Test2134.doc';
            insert cv;
    }
}