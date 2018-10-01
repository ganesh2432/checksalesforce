({  
    save : function(component, event, helper) {
        helper.save(component,event,helper);
    },
    
    waiting: function(component, event, helper) {
        //$A.util.addClass(component.find("uploading").getElement(), "uploading");
        //	$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },
    
    doneWaiting: function(component, event, helper) {
        //$A.util.removeClass(component.find("uploading").getElement(), "uploading");
        //$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },
    handleFilesChange : function(component,event,helper) {
        helper.handleFilesChange(component,event,helper);
    },
    handleRemoveOnly : function(component,event,helper) {
        helper.handleRemoveOnly(component,event,helper);
    },
  
})