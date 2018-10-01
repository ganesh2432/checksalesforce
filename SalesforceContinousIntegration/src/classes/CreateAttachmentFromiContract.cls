public class CreateAttachmentFromiContract {
   public static string finalResponse;
    
    public static void getAttachmentDetails(){
        //Http callout 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/downloadAttachment?entityId=test&attachmentId=1535381585600');
            request.setHeader('x-zycus-tenantId','4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber','12345');
        request.setHeader('Content-Type', 'application/octet-stream');
            request.setTimeout(60000);
            HttpResponse response = http.send(request);
            
            finalResponse = response.getBody();
            //Replacing "" inbetween of the string.
            finalResponse = finalResponse.replace('\"%^\u0026*\"', '');
            system.debug('finalResponse:::::'+finalResponse);
            Response restRes 	= new Response();
            restRes.status 		= response.getStatus();
            restRes.statusCode 	= response.getStatusCode();
            restRes.body 		= finalResponse;   
            
            system.debug(restRes.body );
        
       // response.
        
     /*   ContentVersion cv = new contentVersion();
            cv.ContentLocation = 'S';       
            cv.VersionData = response.getBodyAsBlob();
            cv.Title = 'Updated - Steps for ZSN Integration.docx';
            cv.PathOnClient = 'Updated - Steps for ZSN Integration.docx';
            insert cv;*/
        
 Attachment att=new Attachment();
 att.Body=response.getBodyAsBlob();
        //urlDecode(String inputString, String encodingScheme)
 att.Name='AS08_CM.PDF';
 att.parentId='8007F0000008V1b';
 insert att;
        
        
        // return restRes;  
    }
    
        //response wrapper
    public class Response {
        
        @AuraEnabled
        public String status { get; set; }
        
        @AuraEnabled
        public Integer statusCode { get; set; }
        
        @AuraEnabled
        public String body { get; set; }
    }
}