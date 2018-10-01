public class ComponentsGenricClass {
	 transient static String existingBody;   
     @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
            parentId    = null;
            fileName    = null;
            contentType = null;
            base64Data = null;
        } else {
            parentId    = null;
            fileName    = null;
            contentType = null;
            appendToFile(fileId, base64Data);
            base64Data = null;
        }
 
        return Id.valueOf(fileId);
    }
 
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {       
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion fileToattach = new ContentVersion(); 
        fileToattach.ContentLocation = 'S'; 
        fileToattach.PathOnClient = fileName ;
        fileToattach.Origin = 'H'; 
        fileToattach.Title = fileName;
        fileToattach.IsMajorVersion = false;       
        fileToattach.VersionData = EncodingUtil.base64Decode(base64Data);
        base64Data = null;//added by siva       
        insert fileToattach;
       return fileToattach.Id;
    }
    

    
    private static void appendToFile(Id fileId, String base64Data) {         
       // base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');               
        ContentVersion a = [
            SELECT Id, VersionData
            FROM ContentVersion
            WHERE Id =: fileId
        ];         
        //existingBody        = EncodingUtil.base64Encode(a.VersionData);
        existingBody        = String.ValueOf(a.VersionData);          
        a                   = new ContentVersion(Id = fileId);
        a.VersionData       = null;
        system.debug('Line 119');              
        //a.VersionData       = EncodingUtil.base64Decode(existingBody + base64Data);
        a.VersionData       = Blob.valueOf(existingBody + base64Data);     
        existingBody        = null;
        base64Data =null;
        system.debug('Line 130');
        update a;
        a.VersionData = null;
    }

}