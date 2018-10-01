({
    setParameters : function(component) {
        var recordId = component.get("v.recordId");
        var permission = component.get("v.permission");
        var isImpersonate = this.detectImpersonation();
        var parameters = JSON.stringify({id: recordId, isImpersonate: isImpersonate, egnyte: {permission: permission, id: recordId}, isLightningComponentCall: true});
        component.set("v.parameters", parameters);
    },
    detectImpersonation : function() {
		var value = "; " + document.cookie;
        var parts = value.split("; RSID=");
        if(parts.length == 2)
           return true;
        else
           return false;
	},
    detectSalesforce1 : function(component) {
        var action = component.get("c.getUITheme");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()=='Theme4t') {
                    component.set("v.isSalesforce1", true);
                }
            }
        });
		$A.enqueueAction(action);
    },
    checkRecordId : function(component) {
        var recordIdCheck = component.get("c.validateRecordId");
        recordIdCheck.setParams({
            "recordId" : component.get("v.recordId")     
        });
        recordIdCheck.setCallback(this, function(response) {
            var state = response.getState(),
                value = response.getReturnValue();
            if (state === "SUCCESS") {
                if(value.includes("Not *SF1*")) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": value.slice(9),
                        "type": "error",
                        "duration": "2000",
                        "mode": "pester"
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                }
                else if(value != "Record Id successfully validated.") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": value,
                        "type": "error",
                        "duration": "2000",
                        "mode": "pester"
                    });
                    toastEvent.fire();
                    window.setTimeout(
                        $A.getCallback(function() {
                            $A.get("e.force:closeQuickAction").fire();
                        }), 2000
                    );
                }            
            }
        });
        $A.enqueueAction(recordIdCheck);
    },
    setPath : function(component) {
        var folderPath = component.get("c.getDeepLink");
        var recordId = component.get("v.recordId");
        folderPath.setParams({
            "idParam" : recordId
        });
        folderPath.setCallback(this, function(response) {
        var state = response.getState(),
            value = response.getReturnValue();
        if (state === "SUCCESS") {
            if(value.includes("egnyte://") && value.includes(".egnyte.com/openFolder?path=")) {
                component.set("v.path", value);
            }
            else if(value) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": value,
                    "type": "error",
                    "duration": "2000",
                    "mode": "pester"
                });
                toastEvent.fire();
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.get("e.force:closeQuickAction").fire();
                    }), 2000
                );
            }            
        }
        });
        $A.enqueueAction(folderPath);
    }
})