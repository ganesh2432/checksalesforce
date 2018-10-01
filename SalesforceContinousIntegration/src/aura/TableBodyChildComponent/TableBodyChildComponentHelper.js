({
    //not using as of now
	filledQuestionsHelper : function(component,event) {
		if(component.get("v.RequestWizardInstance").Question__c != ""){
            component.getEvent("FilledQuestion").setParams({"indexVar":component.get("v.rowIndex")}).fire();
        }else{
            component.getEvent("RemovedQuestion").setParams({"indexVar":component.get("v.rowIndex")}).fire();
        }
	}
})