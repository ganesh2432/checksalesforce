@isTest
private class FileUploadCtrlTest {

	@testSetup
    static void createData() { 
    	Account accObj 	= new Account(Name = 'test');
    	insert accObj;
    	Opportunity oppObj 	= new Opportunity(AccountId = accObj.Id, StageName = 'Prospecting',
    										  Name = 'test', CloseDate = Date.today());
    	insert oppObj;
    	Product2 prod = Utility_Test.getProduct();
        insert prod;
        PricebookEntry pBookEntry = Utility_Test.createPricebookEntry(prod.id);
        insert pBookEntry;
    	OpportunityLineItem oppLineItem = Utility_Test.createOpportunityLineItem(pBookEntry, oppObj.id);
        insert oppLineItem;
        Contract contractObj 	= new Contract(AccountId = accObj.Id, Opportunity__c = oppObj.Id);
        insert contractObj;

        ContentVersion fileToattach = new ContentVersion(); 
        fileToattach.ContentLocation = 'S'; 
        fileToattach.PathOnClient = 'test' ;
        fileToattach.Origin = 'H'; 
        fileToattach.Title = 'test';
        fileToattach.IsMajorVersion = false;
        fileToattach.VersionData = EncodingUtil.base64Decode('test');
        insert fileToattach;    
        ContentVersion contentDocIdOfFileAttached = [select ContentDocumentId from ContentVersion where Id =: fileToattach.Id LIMIT 1];
        ContentDocumentLink contentDocLink = new ContentDocumentLink(LinkedEntityId = oppObj.Id, 
                                                                     ContentDocumentId = contentDocIdOfFileAttached.ContentDocumentId, 
                                                                     ShareType = 'I');
        insert contentDocLink;
    }
	
	@isTest static void test_method_one() {
		Contract contractObj 	= new Contract();
		contractObj 			= [Select Id, Name, Opportunity__c from Contract LIMIT 1];
		Test.startTest();

		Id fileId 	= FileUploadCtrl.saveChunk(contractObj.Id, 'test', 'test', 'html', '');
		fileId 		= FileUploadCtrl.saveChunk(contractObj.Id, 'test', 'test', 'html', fileId);

		FileUploadCtrl.createRefDocList(new List<String>{fileId}, new List<String>{'test'}, contractObj.Id);
		FileUploadCtrl.getOpportunityIdFromContract(contractObj.Id);
		FileUploadCtrl.getAllContractFiles(contractObj.Id);
		FileUploadCtrl.getAllOppFiles(contractObj.Id);
		List<FileDetailsWrapper> respList 	= FileUploadCtrl.getAllOppFiles(contractObj.Opportunity__c, contractObj.Id);
		FileUploadCtrl.copyFilesToContract(JSON.serialize(respList), contractObj.Id);
		respList[0].isSelected 	= true;
		FileUploadCtrl.copyFilesToContract(JSON.serialize(respList), contractObj.Id);
		FileUploadCtrl.deleteDocFile(contractObj.Id, [Select Id, ContentDocumentId from ContentVersion LIMIT 1].ContentDocumentId);
		Test.stopTest();
		// Implement test code
	}
	
}