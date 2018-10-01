({
	doInit: function(component, event, helper) {
        component.set("v.Spinner", true);
        component.set("v.mapConfigIdNew",component.get("v.mapConfigId"));
        helper.getIContractFields(component, event, helper,component.get("v.mapConfigId"));
        
	},
	//load the dropdown on click of field.
    popValues : function(component,event,helper){
       component.set("v.Spinner", true);       
       helper.popValues(component,event,helper);
    },
    //Save the values mapping
    savePickVals: function(component,event,helper){
        component.set("v.Spinner", true);
        helper.savePickVals(component,event,helper);
	},
    saveNextClick : function(component,event,helper){               
        component.set("v.finalSavePopup", true);
        helper.inCompleteValueChecking(component,event,helper);
        
        if(component.get("v.finalSavePopup") == true ){
            component.set("v.Spinner", true);
        	var a = component.get('c.savePickVals');
        	$A.enqueueAction(a);
        }
        
        
        //just for testing
        // by jayanth
              //   var compEvent = $A.get("e.c:MovetoNextProgressBarEvt");
              //   compEvent.setParams({"movetoStep" : "step4", "mappingConfigId" : component.get("{!v.mapConfigId}")})                
              //   compEvent.fire();
        
    },
       
    closeModal : function(component,event,helper){
        component.set("v.Spinner", false);
        component.set("v.finalSavePopup", false);
        document.getElementById("SuccessErrorModal").style.display = "none" ;
    },
    onFieldMismatchModalCancel : function(component, event, helper){
        component.set("v.finalSaveWithOutExit", true);
        if(component.get("v.finalSaveWithOutExit") == true ){  
        	var a = component.get('c.popValues');
        	$A.enqueueAction(a);
        }
        document.getElementById("FieldMismatchErrorMessageModal").style.display = "none" ;
    },
    
    onDuplicateValueModalCancel: function(component, event, helper){
        document.getElementById("DuplicateValueErrorMessageModal").style.display = "none" ;
    },
    
})