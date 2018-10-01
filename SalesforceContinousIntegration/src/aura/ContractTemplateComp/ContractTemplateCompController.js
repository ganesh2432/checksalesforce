({
    //onload function which gets template details from contract if its been mapped(mainly in edit contract)
    doinit:function(component,event,helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
         var action = component.get("c.getOpportunityIdFromContract"); 
        var conId = component.get("v.contrctIdToUploadFile");
        action.setParams({
            contractId: conId,
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                var respns = a.getReturnValue();
                //check here if any problem
                component.set("v.stndrduploadedFileName",respns.Template_Name__c);
                component.set("v.stndrduploadedFileId",respns.Template_DocumentId__c);
                //
                component.set("v.uploadedFileId",respns.Template_DocumentId__c);
                component.set("v.uploadedFileName",respns.Template_Name__c);
                component.set("v.IsstandardTemplate",respns.IsStandardTemplate__c);
                component.set("v.opportunityIdforFileUpload",respns.Opportunity__c);
                
                helper.onloadFunction(component,event,helper);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    //after custom file is uploaded method is called and assigned the filename and fileid.
    //so using filename and id the same is being updated in contract fields
    handleUploadFinished : function(component,event,helper) {
        // this is called after file is uploaded
        component.set("v.disabled",true);
        var uploadedFiles = event.getParam("files");
        
        component.set("v.uploadedFileName",uploadedFiles[0].name); 
        component.set("v.uploadedFileId",uploadedFiles[0].documentId);
        
        
        var action = component.get("c.updateTemplateFileDetailsInContract");
        action.setParams({
            "contractId":component.get("v.contrctIdToUploadFile"),
            "docId":uploadedFiles[0].documentId,
            "fileName":uploadedFiles[0].name,
            "isCustomupload":true
        });
        
        action.setCallback(this,function(response){
            var response = response.getReturnValue();
            if(response == 'Success'){
                component.set("v.showuploadedFile",true);
                component.set("v.removeFromOpp",false);
            }
        });       
        $A.enqueueAction(action);
        
    },
    
    //enabling and disabling view of attachments from opp
    enableOpportuityAttachment : function(component,event,helper){
        if(component.get("v.displayOppAttachments")==false){
            component.set("v.displayOppAttachments",true); 
        }else{
            component.set("v.displayOppAttachments",false); 
        }
        
        
    },
    
    showDeleteConfirm : function(component,event,helper){
        $A.util.removeClass(component.find("deleteconfirmppop"),"slds-hide");
            $A.util.addClass(component.find("deleteconfirmppop"),"slds-show");
        //document.getElementById("DeleteFileConfirmationModalTemplate").style.display = "block" ;
    },
    
    //to delete the template file
    deleteTemplateFile:function(component,event,helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        $A.util.removeClass(component.find("deleteconfirmppop"),"slds-show");
            $A.util.addClass(component.find("deleteconfirmppop"),"slds-hide");
        //document.getElementById("DeleteFileConfirmationModalTemplate").style.display = "none" ;
        
        //call apex controller and delete file here
        var action = component.get("c.deleteDocFile"); 
        action.setParams({
            documentId: component.get("v.uploadedFileId"),
            contractId : component.get("v.contrctIdToUploadFile")
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS" && a.getReturnValue() == 'Success') {
                //deleted successfully action
                component.set("v.disabled",false);
                component.set("v.showuploadedFile",false);
                //check later
                component.set("v.uploadedFileName","");
                component.set("v.uploadedFileId","");
            }
            component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
        });
        $A.enqueueAction(action);
    },
    
    closeDeleteConfirm:function(component,event,helper){
         $A.util.removeClass(component.find("deleteconfirmppop"),"slds-show");
            $A.util.addClass(component.find("deleteconfirmppop"),"slds-hide");
        //document.getElementById("DeleteFileConfirmationModalTemplate").style.display = "none" ;
    },
    
    //opportunity selected doc save in coontract
    selectedDocument:function(component,event,helper){
        helper.selectedDocument(component,event,helper);
    },
    
    //view of file from opp attchment list
    viewdocument:function(component,event,helper){
        
        var listIndex		= event.getSource().get("v.value");
        var fileRec 		= component.get("v.existingOppFileList")[listIndex].fileId;
        component.set("v.uploadedFileId",component.get("v.existingOppFileList")[listIndex].fileId);
        window.open("/" + fileRec, '_blank');
    },
    
    //delete of file
    removeSelected:function(component,event,helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        //call apex controller and delete file here
        debugger;
        var action = component.get("c.deleteFileDetailsIncontrct"); 
        action.setParams({
            contractId : component.get("v.contrctIdToUploadFile")
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS" && a.getReturnValue() == 'Success') {
                //deleted successfully action
                component.set("v.stndrduploadedFileName","");
           component.set("v.stndrduploadedFileId","");
                component.set("v.uploadedFileName",""); 
                component.set("v.uploadedFileId","");
                component.set("v.disabled",false);
                component.set("v.showuploadedFile",false);
            }
            component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
        });
        $A.enqueueAction(action);
        
        
    },
    
    //used for styling custom template
    CustomTemplate:function(component,event,helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        component.set("v.customTmplt",true);
        component.set("v.stsndrdTmplt",false);
        if(component.get("v.isEditing")!=true){
        component.set("v.uploadedFileName","");
        component.set("v.uploadedFileId","");
            component.set("v.stndrduploadedFileName","");
        component.set("v.stndrduploadedFileId","");
        component.set("v.disabled",false);
        component.set("v.showuploadedFile",false);
        }
        var Elements = component.find('stndrddTmplt');
        $A.util.removeClass(Elements, "standrdTempltSelectd");
        var Element = component.find('cstmTmplt');
        $A.util.addClass(Element, "standrdTempltSelectd");
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
    },
    
    //used for styling standard template
    standardTemplate:function(component,event,helper){debugger;
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        component.set("v.customTmplt",false);
        component.set("v.stsndrdTmplt",true);
        if(component.get("v.isEditing")!=true){
        component.set("v.uploadedFileName","");
        component.set("v.uploadedFileId","");
        }
        var Elements = component.find('stndrddTmplt');
        $A.util.addClass(Elements, "standrdTempltSelectd");
        var Element = component.find('cstmTmplt');
        $A.util.removeClass(Element, "standrdTempltSelectd");
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
    },
    
    //used for styling standard  template selection
    standardTemplateSelected:function(component,event,helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        var Elements = component.find('bttnmain');
        
        var listIndex		= event.getSource().get("v.value");
        for (var i = 0; i < Elements.length; i++) {
            
            if(i==listIndex){
                $A.util.addClass(Elements[i], "onSelectStyle");
            }else{
                $A.util.removeClass(Elements[i], "onSelectStyle");
            }
        }
        
        if(Elements.length == undefined){
            $A.util.addClass(Elements, "onSelectStyle");
        }
        
        var templatetitle 		= component.get("v.stndrdTemplateList")[listIndex].templateTitle;
        var templatenumber = component.get("v.stndrdTemplateList")[listIndex].templateNumber;

        component.set("v.stndrduploadedFileName",templatetitle);
        component.set("v.stndrduploadedFileId",templatenumber);
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
    },
    
    // to save the template details under contract details
    finishSaveContract:function(component,event,helper){
        helper.finishSaveContract(component,event,helper);
        
    },
    
    closePopUpOK:function(component,event,helper){
        $A.util.removeClass(component.find("fileunslterr"),"slds-show");
        $A.util.addClass(component.find("fileunslterr"),"slds-hide");
     //document.getElementById("fileUnselectedErrorMsg").style.display = "none" ;  
    },
    //used to save template details on keep button click
    keepSaveContrctTemplt : function(component,event,helper){
        var params = event.getParam('arguments');
        if(params){
            component.set("v.iscalledFromKeep",params.param1);
            helper.finishSaveContract(component,event,helper);
        }
    }
    
    
})