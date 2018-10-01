({
    // to check if for particular type and subtype already doc setup is done or not
	doInit : function(component, event, helper) {
		var action = component.get("c.getPicklistValues");
            action.setParams({
                "ObjectApi_name":component.get("v.ObjectName"),
                "Field_name":component.get("v.FieldName")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var PickListValues = response.getReturnValue();
                if (response.getState() === "SUCCESS") {
                    component.set("v.StageNames",PickListValues);
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        //checks if already doc setup is done for the type and subtype or not
        var getExisitingData = component.get("c.getMppingConfigForTypeAndSubType");
            getExisitingData.setParams({
                "typeName":component.get("v.SelectedType"),
                "subType":component.get("v.SelectedSubType")
            });
            // set call back 
            getExisitingData.setCallback(this, function(response) {
                var isDataPresent = response.getReturnValue();
                if (isDataPresent != null && isDataPresent != undefined) {
                    if(isDataPresent.Status__c == 'Active'){
                       component.set("v.isActive",true); 
                    }else{
                        component.set("v.isActive",false); 
                    }
                   component.set("v.SelectedStage",isDataPresent.Allow_Stage__c);
                   component.set("v.StoreSalesforceFile",isDataPresent.Allow_Files__c);
                   component.set("v.AllowLineItems",isDataPresent.Allow_LineItems__c);
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(getExisitingData);
        
	},
    // getting type and subtype from method called by parent
    getTypeAndSubType : function(component, event, helper){
         var args = event.getParam("arguments");
        component.set("v.SelectedType",args.Type);
        component.set("v.SelectedSubType",args.SubType);
    },
    //to save in the backend
    createMappingConfiguration : function(component, event, helper){
        var DocumentSetupWrapper = {types:'',subType:'',allowedStage:'',storeFiles:false,allowLineItem:false}
        if(component.get("v.SelectedStage") == "None" || component.get("v.SelectedStage") == ""){
           document.getElementById("StageEmptyErrorMessage").style.display = "block" ; return;                                                             
        }
        DocumentSetupWrapper.types = component.get("v.SelectedType");
        DocumentSetupWrapper.subType = component.get("v.SelectedSubType");
        DocumentSetupWrapper.allowedStage = component.get("v.SelectedStage");
        DocumentSetupWrapper.storeFiles = component.get("v.StoreSalesforceFile");
        DocumentSetupWrapper.allowLineItem = component.get("v.AllowLineItems");
        
                                                                    
        var action = component.get("c.createMappingConfigurations");
            action.setParams({
                "documentSetupWrpAsString":JSON.stringify(DocumentSetupWrapper)
            });
            // set call back 
            action.setCallback(this, function(response) {
                var PickListValues = response.getReturnValue();
                if (response.getState() === "SUCCESS") {
                    document.getElementById("ActivateMappingConfig").style.display = "block" ; 
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
    },
    // to activate the mapping config
    activateMappingcongif : function(component,event,helper){
        helper.activateMappingcongif(component,event,helper);        
    },
    //not activating mapping config
    dontActivateMappingcongif : function(component,event,helper){
        document.getElementById("ActivateMappingConfig").style.display = "none" ;
        document.getElementById("StageEmptyErrorMessage").style.display = "none" ;
        component.set("v.deactivate",false);
        component.getEvent("goToHomePage").fire();
    },
    closePopUpForRequired: function(component,event,helper){
         document.getElementById("ActivateMappingConfig").style.display = "none" ;
        document.getElementById("StageEmptyErrorMessage").style.display = "none" ;
         component.set("v.deactivate",false);
   },
    // not used as of now but might require in future
    deactiveMappingConfig : function(component,event,helper){
        component.set("v.deactivate",true);
        helper.activateMappingcongif(component,event,helper);
    }
})