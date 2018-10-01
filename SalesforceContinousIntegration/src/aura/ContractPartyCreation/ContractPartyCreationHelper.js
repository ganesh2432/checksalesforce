({
	CreateCPHelper : function(component, event, helper) {
		var accountId = component.get("v.recordId");
        var action = component.get("c.contractPartyCreationCallout");
        action.setParams({"AccountId":accountId});
        action.setCallback(this, function(response){
            component.set("v.Spinner",false);
            var message = response.getReturnValue();
            console.log(message);
            component.set("v.successErrormessage",message);
            document.getElementById("SuccessErrorModal").style.display = "block" ;
        });
        $A.enqueueAction(action);
        
	},
    ContractPartyUpdate : function(component,event,helper){
        var accountId = component.get("v.recordId");
        var objFieldWrap = component.get("v.contractPartySelectedetails");       
        var action = component.get("c.saveSelectedCP");
        action.setParams({"AccountId":accountId,"JsonobjFieldWrap":JSON.stringify(objFieldWrap)});
        action.setCallback(this,function(response){
            component.set("v.Spinner",false);
            var message = response.getReturnValue();
            console.log(message);
            component.set("v.successErrormessage",message);
            document.getElementById("SuccessErrorModal").style.display = "block" ;
        });
        $A.enqueueAction(action);
    }
})