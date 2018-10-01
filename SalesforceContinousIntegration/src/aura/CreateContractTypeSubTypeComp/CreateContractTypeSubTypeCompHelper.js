({
    //fetches the type  values
	fetchPicklistValues : function(component) {
        var action = component.get("c.getTypeAndSubTypeMap");
        action.setParams({"OppId":component.get("v.opportunityId")});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){
                 
                if(response.getReturnValue() == null || response.getReturnValue() == undefined){
                    alert($A.get("$Label.c.Opps_something_went_wrong_msg"));return
                }
                var storeResponse = JSON.parse(response.getReturnValue());
                var strresponse = storeResponse.typeSbTypeMap;
                var enablingAndDisablingData = storeResponse.enabledAndDisable;
                component.set("v.typeSubTypeMap", strresponse);
                component.set("v.enablingAnddisbalingList",enablingAndDisablingData);
                
                var typeEnabledList = [];
                for(var i=0;i<enablingAndDisablingData.length;i++){
                    if(enablingAndDisablingData[i].split("@@")[2]=='Enabled'){
                    typeEnabledList.push(enablingAndDisablingData[i].split("@@")[0]);
                    }
                }
                console.log(typeEnabledList);
                
                var appEvent = $A.get("e.c:StoreTypeSubTypeMapEvt");
                debugger;
                appEvent.setParams({
                    "typeSubTypeMap" : component.get("v.typeSubTypeMap") });
                appEvent.fire();
                var listOfkeys = [];
                var controllerField = []; // for store controller picklist value to set on ui field.
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in strresponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    controllerField.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                        value: $A.get("$Label.c.NONE_Value_in_dropdown") //use ,disabled : "disabled"
                        
                    });
                }
                //this for loop enables and disables the values
                for (var i = 0; i < listOfkeys.length; i++) {
                    if(typeEnabledList.includes(listOfkeys[i])){
                    controllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
                    }else{
                     controllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i],
                         disabled : "disabled"
                    });   
                    }
                }
                var dependentFields = [];
                dependentFields.push({
                class: "optionClass",
                label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                value: $A.get("$Label.c.NONE_Value_in_dropdown")
                });
                component.find('subtypeId').set("v.options", dependentFields);
                component.find('typeId').set("v.options", controllerField);
            }
            /*component.set("v.spinner",false);*/
        });
        $A.enqueueAction(action);
    },
    
    
    
    /*
      Purpose : Method will be called on change of Type. 
     */
    fetchSubTypeValues: function(component, event) {
        component.set("v.typeSelectedValue" ,event.getSource().get("v.value"));
        var typeValueKey 	= event.getSource().get("v.value");
        // get the map values   
        var typeSubTypeMap = component.get("v.typeSubTypeMap");
        var enablingDisablingchecker = component.get("v.enablingAnddisbalingList");
        
        var SubtypeEnabledList = [];
                for(var i=0;i<enablingDisablingchecker.length;i++){
                    if(enablingDisablingchecker[i].split("@@")[2]=='Enabled' && enablingDisablingchecker[i].split("@@")[0]==typeValueKey){
                    SubtypeEnabledList.push(enablingDisablingchecker[i].split("@@")[1]);
                    }
                }
        
        if (typeValueKey != $A.get("$Label.c.NONE_Value_in_dropdown")) {
            var dependentFields = [];
            var listOfSubTypeValues = typeSubTypeMap[typeValueKey];
            dependentFields.push({
                class: "optionClass",
                label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                value: $A.get("$Label.c.NONE_Value_in_dropdown")
            });
            if (listOfSubTypeValues != undefined && listOfSubTypeValues.length > 0) {     
                for (var i = 0; i < listOfSubTypeValues.length; i++) {
                    if(SubtypeEnabledList.includes(listOfSubTypeValues[i])){
                      dependentFields.push({
                        class: "optionClass",
                        label: listOfSubTypeValues[i],
                        value: listOfSubTypeValues[i]
                    });  
                    }else{
                      dependentFields.push({
                        class: "optionClass",
                        label: listOfSubTypeValues[i],
                        value: listOfSubTypeValues[i],
                         disabled : "disabled"
                    });  
                    }
                    
                    //
                    //above for loops enables or diables the values based on criteria checked in apex controller
                    //
                }
                component.set("v.isSubTypeDisable", false);
            }else{
                dependentFields.push({
                    class: "optionClass",
                    label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                    value: $A.get("$Label.c.NONE_Value_in_dropdown")
                });
                component.set("v.isSubTypeDisable", true);
            }
            component.find('subtypeId').set("v.options", dependentFields);
        }else{
            var defaultVal = [{
                class: "optionClass",
                label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                value: $A.get("$Label.c.NONE_Value_in_dropdown")
            }];
            component.find('subtypeId').set("v.options", defaultVal);
            component.set("v.isSubTypeDisable", true);
        }
    },
    
})