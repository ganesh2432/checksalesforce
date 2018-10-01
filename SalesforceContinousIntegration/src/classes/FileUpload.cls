@RestResource(urlMapping='/FileUpload/v1/*')
global with sharing class FileUpload
{
    @HttpPost
    global static String uploadFile(){
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        Blob pic = req.requestBody;
        ContentVersion cv = new contentVersion();
        cv.ContentLocation = 'S';       
        cv.VersionData = pic;
        cv.Title = 'Test12.csv';
        cv.PathOnClient = 'Test12.csv';
        insert cv;
        return cv.Id;
    }
}