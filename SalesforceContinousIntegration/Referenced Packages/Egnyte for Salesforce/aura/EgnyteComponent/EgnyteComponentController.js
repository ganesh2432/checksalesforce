({
	doInit : function(component, event, helper) {
        helper.checkRecordId(component);
        helper.detectSalesforce1(component);
		helper.setParameters(component);
	},
    onCanvasLoad : function(component, event, helper) {
        helper.setPath(component);
    	$A.util.addClass(component.find('mcontent101'),'showBlock');
    	$A.util.addClass(component.find('mcontent102'),'showBlock');
    	$A.util.addClass(component.find('mcontent103'),'showBlock');
	},
    goBack : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
	}    
})