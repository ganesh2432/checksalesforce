({
    // method is called onload of component
    doInit: function(component, event, helper) {  
        helper.doInit(component, event, helper);
    },
    // to select all check box or unselect all the checkbox based on mandatory field
    selectAll: function(component, event, helper) {
       helper.selectAll(component, event, helper);    
    },
    // when a row is selected
    checkboxSelect: function(component, event, helper) {
        helper.checkboxSelect(component, event, helper);
    },
    // to save and go to next step
    saveAndGoNext:function(component,event,helper){
        helper.saveAndGoNext(component, event, helper);
    },
    // to close the opened quick action model
    closequickAction : function(component,event,helper){
        document.getElementById("selectedcountEmpty").style.display = "none" ;
    }
})