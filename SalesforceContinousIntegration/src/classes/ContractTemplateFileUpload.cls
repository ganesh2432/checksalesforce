/*----------------------------------------------------------------------------
* Description :   This class is used to get standard template details from zycus 
*                 and update the user slected or uploaded template file details in contract
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class ContractTemplateFileUpload {
    
    //callout to get standard template details
    @AuraEnabled
    public static ContractStandardTemplateCalloutHelper.Response getStandardTemplateDetails(){
        return ContractStandardTemplateCalloutCtrl.getStandardTemplateDetails();
    }
    
    //used to get opportunity Id from contract
    @AuraEnabled
    public static Contract getOpportunityIdFromContract(String contractId){
        Contract contrct =  [Select Id, Opportunity__c,Template_Name__c,IsStandardTemplate__c,Template_DocumentId__c from Contract where Id =: contractId];
        return contrct;
    }
    
    //upsert of contract template details with reference doc details too
    @AuraEnabled
    public static String updateTemplateFileDetailsInContract(String contractId, String docId, String fileName,boolean isCustomupload){
        try{
            if(contractId!=null && contractId!=''){
                if(isCustomupload){
                    update new Contract(Id=contractId,IContract_Status__c=Constants.SFDC_icontract_status,Template_Name__c=fileName,Template_DocumentId__c=docId,IsStandardTemplate__c=false);
                    upsert new Reference_Documents__c(ExternalID__c=docId+fileName,Contract__c=contractId,File_Name__c=fileName,File_URL__c=docId,Is_Template_Doc__c=true) ExternalID__c;
                }else{
                    update new Contract(Id=contractId,IContract_Status__c=Constants.SFDC_icontract_status,Template_Name__c=fileName,Template_DocumentId__c=docId,IsStandardTemplate__c=true); 
                }
            }
            return 'Success';
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractTemplateFileUpload', 'updateTemplateFileDetailsInContract', e);
            return 'Exception';
        }
    }
    
    //used to get the opportunity files
    @AuraEnabled
    public static List<FileDetailsWrapper> getAllOppTempFiles(String oppId,String contractId){ 
        return FileUploadCtrlService.getAllOppFiles(oppId,contractId);
    }
    
    //use dto delete the referece doc
    @AuraEnabled
    public static String deleteDocFile(String contractId, String documentId){
        try{
            ContentDocument contentObj 	= new ContentDocument(Id = documentId);
            delete contentObj;
            
            List<Reference_Documents__c> refDoc = [Select id,Is_Template_Doc__c from Reference_Documents__c where Is_Template_Doc__c=:true and Contract__c=:contractId];
            if(refDoc.size()>0){
                delete refDoc;
            }
            
            if(contractId!=null && contractId!='')
                update new Contract(Id=contractId,Template_Name__c='',Template_DocumentId__c='',IsStandardTemplate__c=false);
            
            return 'Success';
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractTemplateFileUpload', 'deleteDocFile', e);
            return 'Exception';
        }
        
    }
    
    //used to delete referece doc and its details in contract detail page
    @AuraEnabled
    public static String deleteFileDetailsIncontrct(String contractId){
        try{
            
            if(contractId!=null && contractId!='')
                update new Contract(Id=contractId,Template_Name__c='',Template_DocumentId__c='',IsStandardTemplate__c=false);
            
            List<Reference_Documents__c> refDoc = [Select id,Is_Template_Doc__c from Reference_Documents__c where Is_Template_Doc__c=:true and Contract__c=:contractId];
            if(refDoc.size()>0){
                delete refDoc;
            }
            
            return 'Success';
        }Catch(Exception e){
            HandleBusinessException.captureError('ContractTemplateFileUpload', 'deleteFileDetailsIncontrct', e);
            return 'Exception';
        }
        
    }
    
	//Rahul - To comment
	@AuraEnabled
    public static void createContract(String contractId){
        Contract contractObj    = new Contract();
        contractObj             = [Select Id, IContract_Id__c, IContract_Status__c from Contract where Id =: contractId];
        List<String> statusList = (Constants.NON_EDITED_CONTRACT_STATUSES).split(',');
        if(!statusList.contains(contractObj.IContract_Status__c)){
            if(String.isBlank(contractObj.IContract_Id__c))
                CreateContractAPICtrl.callCreateContract(contractId, null);
            else
                UpdateContractAPICtrl.callUpdateContract(contractId, null);   
        }
    }    
}