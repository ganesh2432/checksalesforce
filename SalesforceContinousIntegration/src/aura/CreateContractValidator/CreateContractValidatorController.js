({
	doInit : function(component, event, helper) {
		var action = component.get("c.isAllowedToCreateContract");
        action.setParams({"OppId":component.get("v.opportunityId")});
    	action.setCallback(this, function(res) {
    		var response 	= res.getReturnValue();
            component.set("v.displayTypeSubType",response);
            component.set("v.spinner",false);
    	});
    	$A.enqueueAction(action);
	}
})