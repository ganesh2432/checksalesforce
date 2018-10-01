({
    /*
     Purpose : Getting 2 objects for which IContract fields will be mapped from Custom Metadata.
               Getting Datatype matching between IContract Datattype and Salesforce Datatype, to filter if Fields are properly mapped.
               Getting all Fields for Object 1 and Object 2, and then filter only suitable fields for particular IContract Field.
    */
    doInit : function(component, event, helper){
        helper.doInit(component, event, helper);
    },
     

    /*
    Not Using
    */ 
    onSelectChangeTableOne : function(component, event, helper) {
        helper.onSelectChangeTableOne(component, event, helper);
    },

    
    /*
    Not Using
    */
    onSelectChangeTabletwo : function(component, event, helper) {
        helper.onSelectChangeTabletwo(component, event, helper);
    },

    
    /*
    Not Using
    */
    getSelectedFields: function(component, event, helper) {
        var allSelectedFields = event.getParam("slectedIcontractField");       
    },
    
    
    onModalCancel: function(component, event, helper) {
    	helper.onModalCancel(component, event, helper);
    }, 
    
    
    onFieldMismatchModalCancel: function(component, event, helper) {
    	helper.onFieldMismatchModalCancel(component, event, helper);
    },
    
    
    onModalConfirm : function(component, event, helper){
        helper.onModalConfirm(component, event, helper);
    },
    
    
    /*
      Purpose : Validate the records before saving and if validate successful, save the records in the system.
    */
    saveRecords: function(component, event, helper) {
    	helper.saveObjectMapping(component, event, helper);
    },
    
    
    /*
      Purpose : To check if new field created is selected, then Open confirm dialog modal.
    */
    onFieldSelectObj : function(component, event, helper){
		helper.onFieldSelectObj(component, event, helper);    
	},
    
    
    /*
      Purpose : To check if new field created is selected for 2nd Object field, then Open confirm dialog modal.
    */
    onFieldSelectSecObj : function(component, event, helper){
		helper.onFieldSelectSecObj(component, event, helper);    
	},


    /*
      Not using
    */
    onSuccessModalClick : function(component, event, helper){
        helper.onSuccessModalClick(component, event,helper);
    }
    
    
})