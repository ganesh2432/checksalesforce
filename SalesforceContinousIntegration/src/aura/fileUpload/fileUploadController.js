({  
    /*
     *Purpose : To get the Opportunity related to Contract. 
     */
    getOppId : function(component, event, helper){
        helper.getOppId(component,event,helper);
    },
    
    
    /*
     *Purpose : To show delete Confirm Dialog box. 
     */
    showDeleteConfirm : function(component, event, helper){
        helper.showDeleteConfirm(component,event,helper);
    },
    
    
    /*
     *Purpose : To hide delete Confirm Dialog box.  
     */
    closeDeleteConfirm : function(component, event, helper){
        helper.closeDeleteConfirm(component,event,helper);
    },
    
    
    /*
     *Purpose : To delete File under Contract Object.  
     */
    deleteFile : function(component, event, helper){
        helper.deleteFile(component,event,helper);
    },
    
    
    /*
     *Purpose : To open File in new Tab.
     */
    onViewClick : function(component, event, helper){
        helper.onViewClick(component, event, helper);
    },
    
    
    /*
     * Purpose : To refresh Files under contract after successful Uploading of File.
     */ 
    handleUploadFinished : function(component,event,helper) {
        debugger;
        helper.handleUploadFinished(component, event, helper);
    },
    
    
    saveRec : function(component,event,helper) {
        debugger;
        helper.saveRec(component, event, helper);
    },
    
    
    sortDocNameDESC : function(component, event, helper){
        helper.sortDocNameDESC(component, event, helper);
    },


    sortDocNameASC : function(component, event, helper){
        helper.sortDocNameASC(component, event, helper);
    },
    
    
    sortDocTypeDESC : function(component, event, helper){
        helper.sortDocTypeDESC(component, event, helper);
    },


    sortDocTypeASC : function(component, event, helper){
        helper.sortDocTypeASC(component, event, helper);
    },
    
    
    sortUploadedByDESC : function(component, event, helper){
        helper.sortUploadedByDESC(component, event, helper);
    },


    sortUploadedByASC : function(component, event, helper){
        helper.sortUploadedByASC(component, event, helper);
    },
    
    
    sortUploadedOnDESC : function(component, event, helper){
        helper.sortUploadedOnDESC(component, event, helper);
    },


    sortUploadedOnASC : function(component, event, helper){
        helper.sortUploadedOnASC(component, event, helper);
    },
    
    
    selectAll : function(component, event, helper){
        helper.selectAll(component, event, helper);
    },
    
    
    checkboxSelect : function(component, event, helper){
        helper.checkboxSelect(component, event, helper);
    },
    
    
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        var choosenFileName = [];
        if (event.getSource().get("v.files").length > 0) {
            for (var i = 0; i < event.getSource().get("v.files")[0].length; i++) {
                var fileSize  = (event.getSource().get("v.files")[0][i]['size']/(1024*1024)).toFixed(2);
                var fileName = event.getSource().get("v.files")[0][i]['name'];
                if(fileSize > 4) {
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title'   : 'File Size Exceeded', 
                        'message' : 'Please select a file with maximum size of 4MB' +fileName
                    }); 
                    showToast.fire();  
                } else {
                	choosenFileName.push(fileName+' --- '+fileSize+'MB');
                }
            }
//            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.selectedFiles", choosenFileName);
        component.set("v.fileName", fileName);
    },
    
    
    handleRemoveOnly : function(component,event,helper) {
        helper.handleRemoveOnly(component,event,helper);
    },
  
    keepSavefileUpld : function(component,event,helper){
        var params = event.getParam('arguments');
        if(params){
            component.set("v.iscalledFromKeepfile",params.params1);
            helper.saveRec(component,event,helper);
        }
    }
})