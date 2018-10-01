({
    /*
     Purpose : Get Type and Sybtype Map from Apex controller, and store the value in typeSubTypeMap Map.
               Add None value in both picklist from Custom Label. 
    */
    fetchPicklistValues : function(component) {
        var action = component.get("c.getTypeAndSubTypeMap");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS"){
                console.log(response.getReturnValue()); 
                var storeResponse = response.getReturnValue();
                component.set("v.typeSubTypeMap", storeResponse);
                var appEvent = $A.get("e.c:StoreTypeSubTypeMapEvt");
                debugger;
                appEvent.setParams({
                    "typeSubTypeMap" : component.get("v.typeSubTypeMap") });
                appEvent.fire();
                var listOfkeys = [];
                var controllerField = []; // for store controller picklist value to set on ui field.
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in storeResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    controllerField.push({
                        class: "optionClass",
                        label: $A.get("$Label.c.NONE_Value_in_dropdown"),
                        value: $A.get("$Label.c.NONE_Value_in_dropdown")
                    });
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    controllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
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
            component.set("v.Spinner", false);
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
                    dependentFields.push({
                        class: "optionClass",
                        label: listOfSubTypeValues[i],
                        value: listOfSubTypeValues[i]
                    });
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
    
    
    /*
     Purpose : To be called on click of Fetch Metatda from iContract Button. It will validate 
               atleast Type should be selected, if Type selected then it will show the next lightning component(Lightning Progress), and will hide current component.
    */
    getMetadata: function(component, event) {
        var selTypeValue 	 = component.get("v.typeSelectedValue");
        var selSubTypeValue  = component.get("v.subTypeSelectedValue");
        var isSubTypeDisable = component.get("v.isSubTypeDisable");
        if(selTypeValue == $A.get("$Label.c.NONE_Value_in_dropdown") || selTypeValue == '' || selTypeValue == undefined
           || (isSubTypeDisable == false && (selSubTypeValue == undefined || selSubTypeValue == $A.get("$Label.c.NONE_Value_in_dropdown") || selSubTypeValue == ''))){
            component.set("v.typeSubTypeErrMsg", $A.get("$Label.c.Type_SubType_Error_Msg"));
            document.getElementById("TypeSubtypeSubmitErrMsgModel").style.display = "block" ;
        }else{
            var cmpEvent = component.getEvent("fetchMDataEvent");
			cmpEvent.setParams({
            "showMapping" : true });
            cmpEvent.setParams({
            "controllingFieldValue" : component.get("v.typeSelectedValue") });
            cmpEvent.setParams({
            "dependentFieldValue" : component.get("v.subTypeSelectedValue") });
	        cmpEvent.fire();
            
        }
    }
})