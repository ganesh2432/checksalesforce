({
    //To display LightningProgressIndicatorForLineItemMapping component and hide iContractBaseComponent component
    EnableLineItemMappings : function(component,event,helper){
        component.find("iContractBaseComp").closeShowMapping();                                                      
        component.set("v.showLineItemMapping", true);
        event.stopPropagation();
    },
    //To display iContractBaseComponent component and hide  LightningProgressIndicatorForLineItemMapping component
    goToHomePage : function(component, event, helper){
        component.set("v.showLineItemMapping", false);
    },
    checkBaseURL : function(component, event, helper){debugger;
        console.log(window.location.href);
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)){
          component.set("v.themeURL", "Theme4d");
        }else{
          component.set("v.themeURL", "Theme3");  
        }                                               
                                                      
    	/*var action = component.get("c.getUIThemeDescription");
    	action.setCallback(this, function(res) {
    		debugger;
    		var response 	= res.getReturnValue();
    		component.set("v.themeURL", response);
    	});
    	$A.enqueueAction(action);

    	var baseURl 	= component.get("v.BaseURL");*/
    }
})