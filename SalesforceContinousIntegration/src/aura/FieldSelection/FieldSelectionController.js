({
  /*
    Purpose : Select or unselect the checkbox, and increment or decrement the Total Count respectively.
  */
	checkboxSelect: function(component, event, helper) {
      helper.checkboxSelect(component, event, helper);
    },
    
    
  /*
    Purpose : Select All or unselect All checkbox.
  */
    selectAll: function(component, event, helper) {
      helper.selectAll(component, event, helper);
     },
    
    
    /*
      Purpose : Save the selected fields in IContract Field Metadata Object against particular Type and Subtype.
    */
     goNext:function(component,event,helper){
         helper.goNext(component, event, helper);
     },


     /*
      Purpose : Close the Error Modal.
    */
     closeSelectionErrModal : function(component, event, helper){
        helper.closeSelectionErrModal(component, event, helper);
     },


     /*
      Purpose : Redirect to home page of the App.
    */
     goToHomePage : function(component, event,helper){
       helper.goToHomePage(component, event, helper);
    },


    /*
      Purpose : Show Exit Configuration Model.
    */
    ExitConfigurationModel : function(component, event,helper){
       helper.ExitConfigurationModel(component, event, helper);
    },


    /*
      Purpose : Onclick of Exit Configuration Model.
    */
    CloseExitConfigurationModel : function(component, event,helper){
       helper.CloseExitConfigurationModel(component, event, helper);
    }
})