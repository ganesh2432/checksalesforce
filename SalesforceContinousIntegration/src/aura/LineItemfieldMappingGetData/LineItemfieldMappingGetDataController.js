({
    // Metadata fetched from Icontract through integration and parsing is done in js not in Apex controller for the response obtained from IContract
	makeRequestToGetLineItemMetaData : function(component, event, helper) {debugger;
		// to get metadata from icontract
        var action = component.get("c.service");
 
        action.setCallback(this, function(responseLineItemData) {
            var LineItemJSONFromEndPoint = responseLineItemData.getReturnValue();
            var jsonBody = LineItemJSONFromEndPoint.body;
            console.log(jsonBody); 
            jsonBody = JSON.parse(jsonBody);
            
            console.log(jsonBody.IntegrationEntities.integrationEntity[0].integrationEntityDetails.metadataDefinition.lineItemMetadata.fieldDetails);     
            var fieldDetails = jsonBody.IntegrationEntities.integrationEntity[0].integrationEntityDetails.metadataDefinition.lineItemMetadata.fieldDetails;
            component.set("v.allLineItemFields",fieldDetails);
            component.set("v.isFieldAvailable",true);
            var self = this;
        });
        
        $A.enqueueAction(action);
	},
    //calling child method to save
    saveAndGoNext : function(component, event, helper){
			component.find("LineItemfieldSelection").saveSelectedLineItems();        
    },
    isFieldAvailableFalse : function(component, event, helper){
        component.set("v.isFieldAvailable",false);
    }
})