({
    //on load called function
	doInit : function(component, event, helper) {
		component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :true}).fire();//on load spinner image which will be closed after the completion of execution
        var action = component.get("c.getExistingLineItemData");  //checks if data exist in salesforce
        action.setParams({
                "isItFromComponent": true
            }); 
        
        action.setCallback(this, function(response) {
            var existingLineItemData = response.getReturnValue();
            var state = response.getState();
            
            var ExistingLineItemfieldsList = [];
            for(var i=0;i<existingLineItemData.length;i++){
                ExistingLineItemfieldsList.push(existingLineItemData[i].Field_Name__c);
            }
            
            var LineItemfieldsListFromAPI = [];
            LineItemfieldsListFromAPI = component.get("v.lineItemData");
            
            if(state == 'SUCCESS'){
                var selectedCounter = 0;
                for(var i=0;i<LineItemfieldsListFromAPI.length;i++){
                    //default checkbox selection if mandatory is true and default selected count of mandatory fields
                    if(ExistingLineItemfieldsList.includes(LineItemfieldsListFromAPI[i].fieldName) || LineItemfieldsListFromAPI[i].mandatory == 'YES'){
                        LineItemfieldsListFromAPI[i].isSelected = true;
                        selectedCounter = selectedCounter + 1;
                    }
                }
                component.set("v.lineItemData",LineItemfieldsListFromAPI);
                component.set("v.selectedCount",selectedCounter);
                // to check Select all check box when all the fields are selected
                if(component.get("v.lineItemData").length == component.get("v.selectedCount")){
                    component.find("selectAllcheckbox").set("v.value", true);
                }else{
                    component.find("selectAllcheckbox").set("v.value", false);
                }
                component.getEvent("LineItemSelectedFieldsCount").setParams({"selectedFieldsCount" :component.get("v.selectedCount")}).fire();//invoking event to set the selected fields count in parent footer
               component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
               
            }
            
        });
        $A.enqueueAction(action);//used to run code synchronously
	},
    // to select all check box or unselect all the checkbox based on mandatory field
    selectAll: function(component, event, helper) {
        //get the header checkbox value  
        var selectedHeaderCheck = event.getSource().get("v.value");
        var getAllId = component.find("boxPack");
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                if(component.find("boxPack").get("v.disabled") == false){
                   component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", 1);   
            }
            
            }else{
                 if(component.find("boxPack").get("v.disabled") == false){
                	component.find("boxPack").set("v.value", false);
                	component.set("v.selectedCount", 0);
                }
            }
        }else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                     if(component.find("boxPack")[i].get("v.disabled") == false){
	                    component.find("boxPack")[i].set("v.value", true);
    	                component.set("v.selectedCount", getAllId.length);
                     }
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                     if(component.find("boxPack")[i].get("v.disabled") == false){
                    	component.find("boxPack")[i].set("v.value", false);
                    	component.set("v.selectedCount", component.get("v.selectedCount") - 1);
                     }
                }
            } 
        }  
        component.getEvent("LineItemSelectedFieldsCount").setParams({"selectedFieldsCount" :component.get("v.selectedCount")}).fire();
    },
    // when a row is selected
     checkboxSelect: function(component, event, helper) {
        // get the selected checkbox value  
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");   
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        component.set("v.selectedCount", getSelectedNumber);

        if(component.get("v.lineItemData").length == component.get("v.selectedCount")){
            component.find("selectAllcheckbox").set("v.value", true);
        }else{
            component.find("selectAllcheckbox").set("v.value", false);
        }  
        
        component.getEvent("LineItemSelectedFieldsCount").setParams({"selectedFieldsCount" :component.get("v.selectedCount")}).fire();
    },
    // to save and go to next step
     saveAndGoNext:function(component,event,helper){
        var allLineItemDatas = component.get("v.lineItemData");
        var selectedLineItems = [];
        var selectedLineItemsForNextPage = [];
        if(component.get("v.selectedCount") < 1){
            document.getElementById("selectedcountEmpty").style.display = "block" ;
        }else{
           for(var i=0;i<allLineItemDatas.length;i++){
                if(allLineItemDatas[i].isSelected == true){
                    selectedLineItems.push(allLineItemDatas[i]);
                    selectedLineItemsForNextPage.push(allLineItemDatas[i]);
                }else{
                    allLineItemDatas[i].isSelected = false;
                    selectedLineItems.push(allLineItemDatas[i]);
                }
            }
            var selectedLineItemStr = JSON.stringify(selectedLineItems);
            var action = component.get("c.createLineItemFieldsMetadata");
            action.setParams({
                "fieldSelectedData": selectedLineItemStr
            }); 
            
            action.setCallback(this, function(response) {
                var res = response.getReturnValue();
                var state = response.getState();
               
                if(state == 'SUCCESS' && res!='Exception'){
                    component.getEvent("LineItemMappingSecondPage").setParams({"movetoStep" : "step2", "mappingSelectedFields" : selectedLineItemsForNextPage}).fire();//moving to next step by firing an event to parent
                }// add else to show opps something went wrong
                
            });
            $A.enqueueAction(action);                   
        }
        
    }
})