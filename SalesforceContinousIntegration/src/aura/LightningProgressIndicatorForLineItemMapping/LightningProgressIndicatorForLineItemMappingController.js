({
	
    // Used by Back button to move Backward
    // Steps of lightning path is controlled by styles
    gotoBcak : function(component, event, helper) {
        var currentStep = component.get("v.currStep");
        if(currentStep == 'step3'){
             $A.util.removeClass(component.find("step3"),"slds-is-current");
            $A.util.removeClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("step3"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step2"),"slds-is-complete");
            $A.util.addClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep2"),"slds-m-left_medium");
            component.set("v.currStep",'step2');
        }else if(currentStep == 'step2'){
            $A.util.removeClass(component.find("step2"),"slds-is-current");
            $A.util.removeClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("step2"),"slds-is-incomplete");
            
            $A.util.removeClass(component.find("step1"),"slds-is-complete");
            $A.util.addClass(component.find("step1"),"slds-is-active");
            $A.util.addClass(component.find("step1"),"slds-is-current");
            $A.util.removeClass(component.find("helpTextStep1"),"slds-m-left_medium");
            component.set("v.currStep",'step1');
        }
    },
    // event fired from Line item selected fields stage and handled here to display count of fields selected in footer
    LineItemSelectedFieldsCount : function(component, event, helper){
        component.set("v.selectedCount",event.getParam("selectedFieldsCount"));
    },
    //Event fired to activate 2nd step
    LineItemMappingSecondPage : function(component, event, helper){
        component.set("v.currStep",event.getParam("movetoStep"));
        component.set("v.mappingSelectedFieldList",event.getParam("mappingSelectedFields"));
        //changing the progress bar status after success from page 1
            $A.util.removeClass(component.find("step1"),"slds-is-active");
            $A.util.removeClass(component.find("step1"),"slds-is-current");
            $A.util.addClass(component.find("step1"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step2"),"slds-is-incomplete");
            $A.util.addClass(component.find("step2"),"slds-is-current");
            $A.util.addClass(component.find("step2"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep1"),"slds-m-left_medium");
    },
    //Event fired to activate 3rd step
    LineItemMappingThirdPage : function(component, event, helper){
        component.set("v.currStep",event.getParam("movetoStep"));
        component.set("v.fieldsForValueMapping",event.getParam("fieldsForValueMapping"));
        $A.util.removeClass(component.find("step2"),"slds-is-active");
            $A.util.removeClass(component.find("step2"),"slds-is-current");
            $A.util.addClass(component.find("step2"),"slds-is-complete");
            
            $A.util.removeClass(component.find("step3"),"slds-is-incomplete");
            $A.util.addClass(component.find("step3"),"slds-is-current");
            $A.util.addClass(component.find("step3"),"slds-is-active");
            $A.util.addClass(component.find("helpTextStep2"),"slds-m-left_medium");
    },
    // to get back to home page
    goToHomePage : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "none" ;
        if(component.get("v.currStep") == 'step1'){
       component.find("LineItemfieldSelection").isFieldAvailableFalse(); 
        }
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
    // on click of save and next + save and exit button based on current step the data is saved in backend by invoking methods of those specific components
    saveFieldselectionofLineItemMapping : function(component, event,helper){
        if(component.get("v.currStep") == 'step1'){//alert(component.get("v.themeURL"));
            component.find("LineItemfieldSelection").saveSelectedLineItems();
         }else if(component.get("v.currStep") == 'step2'){
            component.find("LineItemfieldMapping").saveMappedFields();
         }else if(component.get("v.currStep") == 'step3'){
        }
    },
    // Loading image events handling from childs and in current component
    LineItemMappingSpinnerEvent : function(component, event,helper){
    component.set("v.spinner",event.getParam("spin"));
    },
    //final save of line item mapping
    finalStepSave: function(component, event,helper){
        if(component.get("v.currStep") == 'step3'){
            component.find("LineItemValueMapping").saveMappedValues();
        }
    },
    EvntToDisableSaveAndFinish : function(component, event,helper){
        component.set("v.whenValueMappingISNull",event.getParam("isEmpty"));
    }
})