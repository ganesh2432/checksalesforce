({
   
    // Used by next button to move for further steps
	gotoNext : function(component, event, helper) {
        helper.gotoNext(component, event, helper);
	},


    // Used by Back button to move Backward
    gotoBack : function(component, event, helper) {
        helper.gotoBack(component, event, helper);
    },


    select : function(component, event, helper) {
        helper.select(component, event, helper);            
    },


    next:function(component,event,helper){
        helper.next(component, event, helper);    
    },


    getSelectedFields: function(component, event, helper) {
     helper.getSelectedFields(component, event, helper);
    },
    
    
    setStepNumber: function(component, event, helper) {
        helper.setStepNumber(component, event, helper);
    },
    
    
    getselectedTypeAndSubType:function(component, event, helper) {
        helper.getselectedTypeAndSubType(component, event, helper);
    },


    //when skip button is clicked in Setup Request Wizard step, a Model pop is opened
    enableSkipPopUpFromChild : function(component, event,helper){
        helper.enableSkipPopUpFromChild(component, event, helper);
    },


    //function used to move for document Setup step
    MoveToStepFive : function(component,event,helper){
         helper.MoveToStepFive(component, event, helper);                  
    },

    //Close the model popup which appears on click of ExitConfiguration button
    //Fires an event to get back for Home Page
    goToHomePage : function(component, event,helper){
        helper.goToHomePage(component, event, helper);
    },

    //Close the model popup which appears on click of ExitConfiguration button
    CloseExitConfigurationModel : function(component, event,helper){
        helper.CloseExitConfigurationModel(component, event, helper);
    },

    //Displays the model popup which appears on click of ExitConfiguration button
    ExitConfigurationModel : function(component, event,helper){
       helper.ExitConfigurationModel(component, event, helper);
    },

    DocumentSetupFinish : function(component,event,helper){
      helper.DocumentSetupFinish(component, event, helper);
    },


    setSelectedFieldCount : function(component, event, helper){
        helper.setSelectedFieldCount(component, event, helper);
    }
    
})