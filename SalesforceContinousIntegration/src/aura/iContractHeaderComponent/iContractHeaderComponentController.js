({
	onclickOflineItemMapping : function(component, event, helper) {debugger;
		component.getEvent("EnableLineItemMappings").setParams().fire();
    },
    doInit : function(component,event,helper){
        var action = component.get("c.isDataExist");
 
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
			if(state == "SUCCESS"){
            var isReview = response.getReturnValue();
            component.set("v.isReview",isReview);
            }
        });
        
        $A.enqueueAction(action);
    }
})