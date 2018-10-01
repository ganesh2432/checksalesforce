({
	/*
     Purpose : Get Type and Sybtype Map from Apex controller, and store the value in typeSubTypeMap Map.
               Add None value in both picklist from Custom Label. 
    */
	doInit : function(component, event, helper) {
		component.set("v.Spinner", true);
		helper.fetchPicklistValues(component);
	},
    
    
    /*
      Purpose : Method will be called on change of Type. 
     */
    onTypeFieldChange : function(component, event, helper) {
		helper.fetchSubTypeValues(component, event);
	},
    
    
    /*
     Purpose : To be called on click of Fetch Metatda from iContract Button. It will validate 
               atleast Type should be selected, if Type selected then it will show the next lightning component(Lightning Progress), and will hide current component.
    */
    getMetadata : function(component, event, helper) {
		helper.getMetadata(component, event);
	},
    
    
    /*
    	Purpose : Close the Error Modal div.
    */
    closeErrorMsgModal : function(component, event, helper) {
		document.getElementById("TypeSubtypeSubmitErrMsgModel").style.display = "none" ;
	},
    
    
    /*
    Purpose : To set the Subtype selected in subTypeSelectedValue attribute.
    */
    setSelectedSubTypeValue : function(component, event, helper) {
        var subTypeVal 	= event.getSource().get("v.value");
        if(subTypeVal != $A.get("$Label.c.NONE_Value_in_dropdown"))
        	component.set("v.subTypeSelectedValue" ,event.getSource().get("v.value"));
        else
            component.set("v.subTypeSelectedValue" , '');
	},
})