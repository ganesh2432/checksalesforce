({
	/*
	  Purpose : Return the field to be shown based on particular Type and Subtype from IContract API
	*/
    makeRequest : function(component, event, helper) {
        helper.makeRequest(component, event, helper);
    },
    
    
    /*
      Purpose : Save the selected fields in IContract Field Metadata Object against particular Type and Subtype.
    */
    saveAndGoNext : function(component, event, helper){
        component.find("fieldSelectionCompId").saveFieldMapping();
    },


    goToHomePageOnErrMsg : function(component, event, helper){
        helper.goToHomePageOnErrMsg(component, event, helper);
    }
})