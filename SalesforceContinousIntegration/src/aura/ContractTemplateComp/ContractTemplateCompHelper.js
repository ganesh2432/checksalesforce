({
    //onload function to get exitsing template details from contract
    onloadFunction:function(component,event,helper){
        var action = component.get("c.getAllOppTempFiles"); 
        var conIdval = component.get("v.contrctIdToUploadFile");
        var oppIdval = component.get("v.opportunityIdforFileUpload");
        action.setParams({
            oppId: oppIdval,
            contractId:conIdval
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                component.set("v.existingOppFileList", a.getReturnValue());
                this.getStandardTemplateDataThrougApiCallout(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    selectedDocument:function(component,event,helper){
        var listIndex		= event.getSource().get("v.value");
        var fileRec 		= component.get("v.existingOppFileList")[listIndex].fileId;
        component.set("v.uploadedFileName",component.get("v.existingOppFileList")[listIndex].fileName); 
        component.set("v.uploadedFileId",component.get("v.existingOppFileList")[listIndex].fileId);
        
        
        var action = component.get("c.updateTemplateFileDetailsInContract");
        action.setParams({
            "contractId":component.get("v.contrctIdToUploadFile"),
            "docId":component.get("v.existingOppFileList")[listIndex].fileId,
            "fileName":component.get("v.existingOppFileList")[listIndex].fileName,
            "isCustomupload":true
        });
        
        action.setCallback(this,function(response){
            var response = response.getReturnValue();
            if(response == 'Success'){
                component.set("v.disabled",true);
                component.set("v.showuploadedFile",true); 
                component.set("v.removeFromOpp",true);
            }
        });       
        $A.enqueueAction(action);
        
    },
    
    //To get the list of standard templates from zycus and filtering based on type and subtype of contract
    getStandardTemplateDataThrougApiCallout:function(component,event,helper){
        debugger;
        var getStndrdtmplData = component.get("c.getStandardTemplateDetails"); 
        
        getStndrdtmplData.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                
                if(a.getReturnValue()!=null){
                    try { 
                    var jsonBody = JSON.parse(a.getReturnValue().body);
                    console.log(jsonBody.IntegrationEntities.integrationEntity[0].integrationEntityDetails.templates.templateList);
                    var templateLists = jsonBody.IntegrationEntities.integrationEntity[0].integrationEntityDetails.templates.templateList;
                    
                    var standardTemplateDetails = [];
                    
                    for(var i=0;i<templateLists.length;i++){
                        if(templateLists[i].type==component.get("v.typeValue") && templateLists[i].subType==component.get("v.subTypeValue")){
                            standardTemplateDetails = templateLists[i].templatesByType.template;
                        }
                    }
                    //standardTemplateDetails.push({templateNumber: "JB102", templateTitle: "Legal Template", templateDescription: "", templateFor: "Contract", language: "English"});
                    //standardTemplateDetails.push({templateNumber: "JB012", templateTitle: "Legal Template", templateDescription: "", templateFor: "Contract", language: "English"});
                    
                    component.set("v.stndrdTemplateList",standardTemplateDetails);
                    }
                    catch(err){
                        alert('Zycus Standard template Service not available');
                    }
                }
                this.editingContract(component,event,helper);
            }
        });
        $A.enqueueAction(getStndrdtmplData);
    },
    
    //Saving contract template details
    finishSaveContract:function(component,event,helper){
         if(component.get("v.customTmplt")==false){
           component.set("v.uploadedFileName",component.get("v.stndrduploadedFileName"));
           component.set("v.uploadedFileId",component.get("v.stndrduploadedFileId"));              
         }
        
        
        if(component.get("v.uploadedFileName")!="" && component.get("v.uploadedFileName")!=undefined ){
            var iscustmtmp = false;
            if(component.get("v.customTmplt")==true){
                iscustmtmp = true;
            }
            var action = component.get("c.updateTemplateFileDetailsInContract");
            action.setParams({
                "contractId":component.get("v.contrctIdToUploadFile"),
                "docId":component.get("v.uploadedFileId"),
                "fileName":component.get("v.uploadedFileName"),
                "isCustomupload":iscustmtmp
            });
            
            action.setCallback(this,function(response){
                var response = response.getReturnValue();
                if(response == 'Success'){
                    debugger;
                    this.createContractAPI(component,event,helper);
                    if(component.get("v.iscalledFromKeep")==false){
                    this.redirctToOppDetailPage(component,event,helper);
                    }else{
                    component.getEvent("KeepSaveEvnt").setParams({"isSaved" :true}).fire();    
                    }
                }
            });       
            $A.enqueueAction(action);
        }else{
            if(component.get("v.iscalledFromKeep")==false){
            //document.getElementById("fileUnselectedErrorMsg").style.display = "block" ;
            $A.util.removeClass(component.find("fileunslterr"),"slds-hide");
            $A.util.addClass(component.find("fileunslterr"),"slds-show");
            }else{
                component.getEvent("KeepSaveEvnt").setParams({"isSaved" :true}).fire();
            }
        }
    },
    
    
    createContractAPI : function(component,event,helper) {
        var action = component.get("c.createContract");
            action.setParams({
                "contractId":component.get("v.contrctIdToUploadFile")
            });
            
            action.setCallback(this,function(response){
                var response = response.getReturnValue();
            });       
            $A.enqueueAction(action);
    },
    
    
    redirctToOppDetailPage : function(component,event,helper) {
        
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)){
            // for lightning view
            var Opprec  = component.get("v.contrctIdToUploadFile");
            
            var sObectEvent = $A.get("e.force:navigateToSObject");
            sObectEvent .setParams({
                "recordId": Opprec  ,
                "slideDevName": "detail"
            });
            sObectEvent.fire();
        }else{
            //for classic view
            window.location.href = "/"+component.get("v.contrctIdToUploadFile"); 
        }
        
    },
    
    //for styling and default selection of standard/custom template with details
    editingContract : function(component,event,helper){
       
        if(component.get("v.uploadedFileId")!=null && component.get("v.uploadedFileId")!=''){
            if(component.get("v.IsstandardTemplate")==true){
                var Elements = component.find('stndrddTmplt');
                $A.util.addClass(Elements, "standrdTempltSelectd");
                var Element = component.find('cstmTmplt');
                $A.util.removeClass(Element, "standrdTempltSelectd");
                component.set("v.disabled",true);
                component.set("v.showuploadedFile",true); 
                component.set("v.removeFromOpp",true);
                component.set("v.customTmplt",false);
                component.set("v.stsndrdTmplt",true);
                //component.set("v.uploadedFileId","");
                //component.set("v.uploadedFileName","");

            }else{
                var Elements = component.find('stndrddTmplt');
                $A.util.removeClass(Elements, "standrdTempltSelectd");
                var Element = component.find('cstmTmplt');
                $A.util.addClass(Element, "standrdTempltSelectd");
                component.set("v.disabled",true);
                component.set("v.showuploadedFile",true); 
                component.set("v.removeFromOpp",true);
                component.set("v.customTmplt",true);
                component.set("v.stsndrdTmplt",false);
                
            }
        }
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
    }
})