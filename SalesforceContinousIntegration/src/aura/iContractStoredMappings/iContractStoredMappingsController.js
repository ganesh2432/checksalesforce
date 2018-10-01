({
    /*
        Purpose : Get all Mapping config Records needs to be shown in Table.
    */
    doInit : function(component, event, helper) {
		helper.fetchContractConfigRecords(component);
	},
    
	/* Not using */
    fetchMetaData: function(component, event, helper) {
		helper.fetchMetaDataHelper(component,event,helper);
	},
    
    
    /*
     Purpose : On click of Menu items, either activate, delete or deactivate contract.
    */
    onClickOfMenuButtons : function(component, event, helper) {
        helper.onClickOfMenuButtons(component, event, helper);
    },
    
    
    /*
     Purpose : On Click of Confirm of Activate Contract Modal.       
    */
    onActivateModalConfirm : function(component, event, helper) {
        helper.onActivateModalConfirm(component, event, helper);
    },
    
    
    /*
     Purpose : On Click of Cancel of Delete Contract Modal.       
    */
    onDeleteModalCancel : function(component, event, helper) {
        document.getElementById("DeleteMappingConfigurationModal").style.display = "none" ;
    },
    
    
    /*
     Purpose : On Click of Confirm of Delete Contract Modal.       
    */
    onDeleteModalConfirm : function(component, event, helper) {
        helper.onDeleteModalConfirm(component, event, helper);
    },
    
    
    onDeleteResModalConfirm : function(component, event, helper) {
        helper.onDeleteResModalConfirm(component, event, helper);
    },
    

    /*
     Purpose : On Click of Review button.       
    */    
    onReviewClick : function(component, event, helper){
        helper.onReview(component, event, helper);
    },
    
    
    /*
     Purpose : Handler of StoreTypeSubTypeMapEvt Event.
    */
    storeTypeSubTypeMapEvt : function(component, event, helper){
        helper.storeTypeSubTypeMapEvt(component, event, helper);
    },
    
    
    /*
      Purpose : Method will be called on change of Type. 
     */
    onTypeFieldChange : function(component, event, helper) {
		helper.fetchSubTypeValues(component, event);
	},
    
    
    /*
      Purpose : OnChange of Subtype dropdown.
     */
    setSelectedSubTypeValue : function(component, event, helper) {
        helper.setSelectedSubTypeValue(component, event, helper);
	},
    
    	
    closeCopyModal : function(component, event, helper){
        debugger;
        document.getElementById("CopyConfigurationModel").style.display = "none" ;
    },
    
    
    closeCopyErrModal : function(component, event, helper){
        helper.closeCopyErrModal(component, event, helper);
    },
    
    
    /*
      Purpose : Method to be called on Copy event.
    */
    validateAndCopyMapping : function(component, event, helper){
        helper.validateAndCopyMapping(component, event, helper);
    },


    /*
     Sorting based on Contract Type Column
    */
    sortTypeDESC : function(component, event, helper){
       helper.sortTypeDESC(component, event, helper);
    },


    sortTypeASC : function(component, event, helper){
        helper.sortTypeASC(component, event, helper);
    },


    /*
     Sorting based on Contract sub-Type Column
    */
    sortSubTypeDESC : function(component, event, helper){
        helper.sortSubTypeDESC(component, event, helper);
    },


    sortSubTypeASC : function(component, event, helper){
        helper.sortSubTypeASC(component, event, helper);
    },


    /*
     Sorting based on Status Column
    */
    sortStatusDESC : function(component, event, helper){
        helper.sortStatusDESC(component, event, helper);
    },


    sortStatusASC : function(component, event, helper){
        helper.sortStatusASC(component, event, helper);
    },


    /*
     Sorting based on Created By Column
    */
    sortCreatedByDESC : function(component, event, helper){
        helper.sortCreatedByDESC(component, event, helper);
    },


    sortCreatedByASC : function(component, event, helper){
        helper.sortCreatedByASC(component, event, helper);
    },


    /*
     Sorting based on Last Updated On Column
    */
    sortUpdatedOnDESC : function(component, event, helper){
        helper.sortUpdatedOnDESC(component, event, helper);
    },


    sortUpdatedOnASC : function(component, event, helper){
        helper.sortUpdatedOnASC(component, event, helper);
    }
})