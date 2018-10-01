({
   // on load function for to check component running environment and to enable line item question while creation
    doInit : function(component, event, helper){
        var locURL =  window.location.href;
            var lightningURL = $A.get("$Label.c.Lightning_URL");
            if(locURL.includes(lightningURL)){
                component.set("v.themeURL", "Theme4d");
            }else{
                component.set("v.themeURL", "Theme3");  
            }
        
        var action = component.get("c.isLineItemAllowed");
        action.setParams({
                "selectedType":component.get("v.typeSelectedValue"),
                "selectedSubType":component.get("v.subTypeSelectedValue")
            });
        action.setCallback(this,function(response){
            if(response.getReturnValue()=="Exception"){
                alert($A.get("$Label.c.Opps_something_went_wrong_msg"));
                return;
            }
            var responseval = JSON.parse(response.getReturnValue());
            component.set("v.isLineItemAllowed",responseval);
            
       });       
            $A.enqueueAction(action);
        
    },
    //used to save the changes of current page and move to next page
    saveAndNext : function(component, event, helper) {
        if(component.get("v.currStep") == 'step1'){
            component.find("createcontractcomp").saveContract();
        }else if(component.get("v.currStep") == 'step2'){
            component.find("fileUploadCmpId").saveFileUpload();
            //cerrstep and style needs to be set in another event
           component.set("v.currStep",'step3');
            //changing the progress bar status after success from page 1
        $A.util.removeClass(component.find("step2"),"slds-is-active");
        $A.util.removeClass(component.find("step2"),"slds-is-current");
        $A.util.addClass(component.find("step2"),"slds-is-complete");
        
        $A.util.removeClass(component.find("step3"),"slds-is-incomplete");
        $A.util.addClass(component.find("step3"),"slds-is-current");
        $A.util.addClass(component.find("step3"),"slds-is-active");
        $A.util.addClass(component.find("helpTextStep1"),"slds-m-left_medium");
            
        }else if(component.get("v.currStep") == 'step3'){
            component.find("contractTemplateCompnent").finishContract();
        }
    },
    // on save of first step event fired to move to second step
    CreateContrctSecondPage : function(component,event,helper){
        component.set("v.contractRecId",event.getParam("contractRecordId"));
        component.set("v.contrctIdFroTemplatecreation",event.getParam("contractRecordId"));
        component.set("v.currStep",event.getParam("moveToStepNo"));
        //changing the progress bar status after success from page 1
        $A.util.removeClass(component.find("step1"),"slds-is-active");
        $A.util.removeClass(component.find("step1"),"slds-is-current");
        $A.util.addClass(component.find("step1"),"slds-is-complete");
        
        $A.util.removeClass(component.find("step2"),"slds-is-incomplete");
        $A.util.addClass(component.find("step2"),"slds-is-current");
        $A.util.addClass(component.find("step2"),"slds-is-active");
        $A.util.addClass(component.find("helpTextStep1"),"slds-m-left_medium");
    },
    
    //redirect to opportunity detail page
    redirectToOppDetailPage : function(component,event,helper){
      helper.redirectToOppDetailPage(component,event,helper);
    },
    
    //displays keep and discard popup
    closePopUp : function(component,event,helper){
        //document.getElementById("canclePopUp").style.display = "none" ;
        $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-show");
		$A.util.addClass(component.find("canclePopUpconfirm"),"slds-hide");
    },
    
    //redirect to opp detail page based on steps and contract created or not and based on edit or create of contrct
    redirectToOppPageConfirmation : function(component,event,helper){
        
        if(component.get("v.currStep") == 'step1' && component.get("v.isEditing")==false && component.get("v.scoperunningcreate")==true){
        helper.redirectToOppDetailPage(component,event,helper);
        }else if(component.get("v.isEditing")==true && component.get("v.scoperunningcreate")==false){
            
            if(component.get("v.isContractnumPresent") != true){
               $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-hide");
               $A.util.addClass(component.find("canclePopUpconfirm"),"slds-show"); 
            }else{
             helper.redirectToOppDetailPage(component,event,helper);   
            }
           
        }else{
           $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-hide");
           $A.util.addClass(component.find("canclePopUpconfirm"),"slds-show"); 
        }
    },
    //spinner method
    CreateContractSpinnerEventmethod : function(component,event,helper){
        component.set("v.spinner",event.getParam("spin"));
    },
    //event which gives the supporting doc file counts from2nd step
    fileSelectedCount : function(component,event,helper){
        component.set("v.selectedFieldsCountOfdoc",event.getParam("selectedFieldsCount"));
    },
    //assigning contract party name from 1st stage component too parent component
    contrctPartyName:function(component,event,helper){
        var cntrctpartyName		= event.getParam("CPName");
        component.set("v.contractingParty",cntrctpartyName);
    },
    // back button functionality
    backbuttonFunction : function(component,event,helper){
        component.set("v.isEditing",true);
        //alert(component.get("v.opportunityId"));
        //alert(component.get("v.contractRecId"));
        //component.set("v.saveonBackAttachmnts",false);
        if(component.get("v.currStep") == 'step3'){
            
           // component.find("contractTemplateCompnent").keepSave(true);
            $A.util.removeClass(component.find("step3"),"slds-is-current");
            $A.util.removeClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("step3"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step2"),"slds-is-complete");
            $A.util.addClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-current");
            component.set("v.currStep",'step2');
        }else if(component.get("v.currStep") == 'step2'){
          //  component.find("fileUploadCmpId").keepSavefileupld(true);
            $A.util.removeClass(component.find("step2"),"slds-is-current");
            $A.util.removeClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step1"),"slds-is-complete");
            $A.util.addClass(component.find("step1"),"slds-is-active");
            $A.util.addClass(component.find("step1"),"slds-is-current");
            component.set("v.currStep",'step1');
        }
    },
    // to delete contract data onclilck of discard button
    discardContractData : function(component,event,helper){
        
            var action = component.get("c.deleteContract");
        action.setParams({
                "contrctId":component.get("v.contractRecId")
            });
        debugger;
        action.setCallback(this,function(response){
            if(response.getReturnValue()=="Exception"){
                alert($A.get("$Label.c.Opps_something_went_wrong_msg"));
                return;
            }
            if(component.get("v.isContractnumPresent") != true){
                component.set("v.redirectToOppOndiscrd",true);
            }
            var responseval = response.getReturnValue();
            helper.redirectToOppDetailPage(component,event,helper);
            
       });       
            $A.enqueueAction(action);
            
    },
    // to save changes made by user onclick of keep button and redirecting to opp/contrct detail page
    keepContractData : function(component,event,helper){
        //component.set("v.saveonBackAttachmnts",true);
        if(component.get("v.currStep") == 'step1'){
            helper.redirectToOppDetailPage(component,event,helper);
        }else if(component.get("v.currStep") == 'step2'){
            component.find("fileUploadCmpId").keepSavefileupld(true);
            $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-show");
		    $A.util.addClass(component.find("canclePopUpconfirm"),"slds-hide");
           // helper.redirectToOppDetailPage(component,event,helper);
        }else if(component.get("v.currStep") == 'step3'){
            component.find("contractTemplateCompnent").keepSave(true);
            $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-show");
		    $A.util.addClass(component.find("canclePopUpconfirm"),"slds-hide");
           // helper.redirectToOppDetailPage(component,event,helper); 
        }
        
    },
    closePopUpForligthncrtcontrct:function(component,event,helper){
        $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-show");
		    $A.util.addClass(component.find("canclePopUpconfirm"),"slds-hide");
    },
    KeepSaveEvntfunction:function(component,event,helper){
        var isSavedSuccessfully		= event.getParam("isSaved");
        //if(isSavedSuccessfully && saveonBackAttachmnts)
        if(isSavedSuccessfully)
        helper.redirectToOppDetailPage(component,event,helper);
    }
})