({
    // to activate the mapping config
	activateMappingcongif : function(component,event,helper){
        document.getElementById("ActivateMappingConfig").style.display = "none" ;
        //condition might be used in future 
        //if(!component.get("v.deactivate")){
           component.set("v.Activate","Active"); 
        /*}else{
           component.set("v.Activate","InActive"); 
        }*/
        
        var ActivateWrapper = {types:'',subType:'',activateMappingconfig:''}
        ActivateWrapper.types = component.get("v.SelectedType");
        ActivateWrapper.subType = component.get("v.SelectedSubType");
        ActivateWrapper.activateMappingconfig = component.get("v.Activate");
        
        var action = component.get("c.activateMappingConfigurations");
            action.setParams({
                "activateMappngConfigAsString":JSON.stringify(ActivateWrapper)
            });
            // set call back 
            action.setCallback(this, function(response) {debugger;
                var PickListValues = response.getReturnValue();
                if (response.getState() === "SUCCESS") {component.getEvent("goToHomePage").fire();}
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        
        
    }
})