({
	gotoFieldMapping: function(component, event, helper) {

		/* Fire Selected type and subtype value to parent */
		component.set("v.showMappingComponent", true);
	},

	handleTypeSubTypeValue: function(component, event, helper) {
		component.set("v.selectedType",event.getParam("controllingFieldValue"));
		component.set("v.selectedSubType",event.getParam("dependentFieldValue"));
		event.stopPropagation();	
	},
    
    
    handleShowMapping: function(component, event, helper) {
		component.set("v.showMappingComponent",event.getParam("showMapping"));
        component.set("v.selectedType",event.getParam("controllingFieldValue"));
		component.set("v.selectedSubType",event.getParam("dependentFieldValue"));
		event.stopPropagation();	
	},
    goToHomePage : function(component, event, helper){debugger;
        component.set("v.showMappingComponent", false);
    },

    checkBaseURL : function(component, event, helper){
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)) component.set("v.themeURL", "Theme4d");
        else component.set("v.themeURL", "Theme3");
        
        component.set("v.showMappingComponent",false);
    	var action = component.get("c.getUIThemeDescription");
    	action.setCallback(this, function(res) {
    		debugger;
    		var response 	= res.getReturnValue();
    		component.set("v.themeURL", response);
    		console.log(response);
    	});
//    	$A.enqueueAction(action);

    }
})