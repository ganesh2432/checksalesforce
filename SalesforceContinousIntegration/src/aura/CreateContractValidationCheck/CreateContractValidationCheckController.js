({
	doInit : function(component, event, helper) {
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)){
          component.set("v.themeURL", "Theme4d");
        }else{
          component.set("v.themeURL", "Theme3");  
        }
	}
})