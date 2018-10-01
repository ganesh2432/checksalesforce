({
	// Used by next button to move for further steps
	gotoNext : function(component, event, helper) {
		var currentStep = component.get("v.currStep");
        if(currentStep == 'step1'){ 
            component.find("fieldMappingCompId").saveFieldMapping();
        }else if(currentStep == 'step2'){
            component.find("objectBasedFieldMappingCompId").saveObjectFieldMapping();
        }else if(currentStep == 'step3'){
            component.find("valueMapping").savePickValues();
        }else if(currentStep == 'step4'){
            component.find("tableheaderComponent").saveContractRequestWizardInChild();
        }
	},
    
    // Used by Back button to move Backward
    gotoBack : function(component, event, helper) {
        var currentStep = component.get("v.currStep");
        if(currentStep == 'step5'){
            $A.util.removeClass(component.find("step5"),"slds-is-current");
            $A.util.removeClass(component.find("step5"),"slds-is-active");
            $A.util.addClass(component.find("step5"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step4"),"slds-is-complete");
            $A.util.addClass(component.find("step4"),"slds-is-active");
            $A.util.addClass(component.find("step4"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep4"),"slds-m-left_medium");
            
            component.set("v.currStep","step4");
        }else if(currentStep == 'step4'){
             $A.util.removeClass(component.find("step4"),"slds-is-current");
            $A.util.removeClass(component.find("step4"),"slds-is-active");
            $A.util.addClass(component.find("step4"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step3"),"slds-is-complete");
            $A.util.addClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("step3"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep3"),"slds-m-left_medium");
            component.set("v.currStep","step3");
        }else if(currentStep == 'step3'){
             $A.util.removeClass(component.find("step3"),"slds-is-current");
            $A.util.removeClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("step3"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step2"),"slds-is-complete");
            $A.util.addClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep2"),"slds-m-left_medium");
            component.set("v.currStep","step2");
        }else if(currentStep == 'step2'){
             $A.util.removeClass(component.find("step2"),"slds-is-current");
            $A.util.removeClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step1"),"slds-is-complete");
            $A.util.addClass(component.find("step1"),"slds-is-active");
            $A.util.addClass(component.find("step1"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep1"),"slds-m-left_medium");
            component.set("v.currStep","step1");
        }
    },
    select : function(component, event) {
           
            for(var i =0 ; i < component.find("liList").length; i++){
                $A.util.removeClass(component.find("liList")[i], "slds-is-current");
                $A.util.addClass(component.find("liList")[i],"slds-is-incomplete");
                 var pc= component.find("path-content-" + i);
                $A.util.removeClass(pc,"slds-show");
                $A.util.addClass(pc,"slds-hide");
                
            }
            var index = event.target.getAttribute("data-index");
           
            event.target.setAttribute("aria-selected","true");
            
            $A.util.removeClass(component.find("liList")[index], "slds-is-incomplete");
            $A.util.addClass(component.find("liList")[index],"slds-is-current slds-is-active");
            $A.util.addClass(component.find("path-content-" + index),"slds-show");
          },
          next:function(component,event,helper){
            
          },
    getSelectedFields: function(component, event, helper) {
     //   alert('msg in parent');
        var message = event.getParam("slectedIcontractField");

    },
    
    
    setStepNumber: function(component, event, helper) {
        var message 	= event.getParam("movetoStep");
        var mapConfId 	= event.getParam("mappingConfigId");
		
        var currentStep = component.get("v.currStep");
        if(currentStep == 'step1'){ 
            
            $A.util.removeClass(component.find("step1"),"slds-is-active");
            $A.util.removeClass(component.find("step1"),"slds-is-current");
            $A.util.addClass(component.find("step1"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step2"),"slds-is-incomplete");
            $A.util.addClass(component.find("step2"),"slds-is-current");
            $A.util.addClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep1"),"slds-m-left_medium");
		}else if(currentStep == 'step2'){
            $A.util.removeClass(component.find("step2"),"slds-is-active");
            $A.util.removeClass(component.find("step2"),"slds-is-current");
            $A.util.addClass(component.find("step2"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step3"),"slds-is-incomplete");
            $A.util.addClass(component.find("step3"),"slds-is-current");
            $A.util.addClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep2"),"slds-m-left_medium");
        }else if(currentStep == 'step3'){
           $A.util.removeClass(component.find("step3"),"slds-is-active");
            $A.util.removeClass(component.find("step3"),"slds-is-current");
            $A.util.addClass(component.find("step3"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step4"),"slds-is-incomplete");
            $A.util.addClass(component.find("step4"),"slds-is-current");
            $A.util.addClass(component.find("step4"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep3"),"slds-m-left_medium");

        }
        component.set("v.currStep",message);
        component.set("v.mapConfigId",mapConfId);
        
    },
    
    
    getselectedTypeAndSubType:function(component, event, helper) {
        var controllingFieldValue = event.getParam("controllingFieldValue");
        var dependentFieldValue = event.getParam("dependentFieldValue");
        component.set("v.selectedType",controllingFieldValue);
        component.set("v.selectedSubType",dependentFieldValue);
    },


    //when skip button is clicked in Setup Request Wizard step, a Model pop is opened
    enableSkipPopUpFromChild : function(component, event,helper){
        component.find("tableheaderComponent").openSkipPopUp();
    },


    //function used to move for document Setup step
    MoveToStepFive : function(component,event,helper){
         component.set("v.currStep",'step5');
         component.find("DocSetup").passTypeAndSubType(component.get("v.selectedType"),component.get("v.selectedSubType"));
            $A.util.removeClass(component.find("step4"),"slds-is-active");
            $A.util.removeClass(component.find("step4"),"slds-is-current");
            $A.util.addClass(component.find("step4"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step5"),"slds-is-incomplete");
            $A.util.addClass(component.find("step5"),"slds-is-current");
            $A.util.addClass(component.find("step5"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep4"),"slds-m-left_medium");
                                           
    },

    //Close the model popup which appears on click of ExitConfiguration button
    //Fires an event to get back for Home Page
    goToHomePage : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "none" ;
       component.getEvent("goToHomePage").fire();
    },


    //Close the model popup which appears on click of ExitConfiguration button
    CloseExitConfigurationModel : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "none" ; 
    },


    //Displays the model popup which appears on click of ExitConfiguration button
    ExitConfigurationModel : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "block" ; 
    },


    DocumentSetupFinish : function(component,event,helper){
      component.find("DocSetup").finishSetup(); 
      //component.getEvent("goToHomePage").fire();
    },


    setSelectedFieldCount : function(component, event, helper){
        component.set("v.selectedFieldCount", event.getParam("selectedFieldCount"));
        event.stopPropagation();
    }
})