({
	fetchContractConfigRecords: function(component) {
        
		var action = component.get("c.getContractMappingRecords");
        action.setCallback(this, function(response) {
            var result 	= response.getReturnValue();
            component.set('v.contractConfigRec',result);
            if(result.length > 0){
              	component.set('v.isContractConfigFound', true);  
            } 
        })
        $A.enqueueAction(action);
	},
    
    
    fetchMetaDataHelper: function(component, event, helper) {

		var action = component.get("c.getMetaDatadetails");
        action.setCallback(this, function(response) {
            var objectMap = response.getReturnValue();
            component.set('v.AllreadyMappedValues',objectMap);
        })
        $A.enqueueAction(action);
	},
    
    
    storeTypeSubTypeMapEvt: function(component, event, helper){
        component.set("v.typeSubTypeMap",event.getParam("typeSubTypeMap"));
        var storeResponse 	= component.get("v.typeSubTypeMap");
        var listOfkeys 		= [];
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
    },
    
    
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
    
    
    setSelectedSubTypeValue : function(component, event, helper) {
        var subTypeVal 	= event.getSource().get("v.value");
        if(subTypeVal != $A.get("$Label.c.NONE_Value_in_dropdown"))
        	component.set("v.subTypeSelectedValue" ,event.getSource().get("v.value"));
        else
            component.set("v.subTypeSelectedValue" , '');
	},
    
    
    onClickOfMenuButtons : function(component, event, helper) {
   //     debugger;
    	var selectedMenuItemValue = event.getParam("value");
        var listIndex 			  = selectedMenuItemValue.substring(selectedMenuItemValue.length - 1, selectedMenuItemValue.length);
        if(selectedMenuItemValue.includes(component.get("v.deactivateButton"))){
            this.deactivateContract(component, event, helper, listIndex);
        }else{
            if(selectedMenuItemValue.includes(component.get("v.activateButton"))){
                this.activateContract(component, event, helper, listIndex);
            }
        }
        if(selectedMenuItemValue.includes(component.get("v.copyButton"))){
            this.copyContract(component, event, helper, listIndex);
        }
        if(selectedMenuItemValue.includes(component.get("v.deleteButton"))){
            this.deleteContract(component, event, helper, listIndex);
        }
	},
    
    
    activateContract : function(component, event, helper, listIndex){
        var contractRec 	= component.get("v.contractConfigRec")[listIndex];
        if(contractRec.Stage__c != 'Step 5'){
            var message = $A.get("$Label.c.Complete_All_Steps");
            component.set("v.activateModalMsg", message); 
            document.getElementById("ActivateMappingConfigurationModal").style.display = "block" ;
        }
        else if(contractRec.Status__c != $A.get("$Label.c.Mapping_Status_Active")){
            var action = component.get("c.activateContract");
            action.setParams({
    	        "contractId" : contractRec.Id
	        });
 //           debugger;
            action.setCallback(this, function(response) {
                var res 	= response.getReturnValue();
                res 		= "<b>" + res + "</b>";
                component.set("v.activateModalMsg", res); 
                document.getElementById("ActivateMappingConfigurationModal").style.display = "block" ;
            });
            $A.enqueueAction(action);
        }else{
            var message = $A.get("$Label.c.Record_already_Active_Err_Msg");
			component.set("v.activateModalMsg", message); 
            document.getElementById("ActivateMappingConfigurationModal").style.display = "block" ;
        }
    },


    deactivateContract : function(component, event, helper, listIndex){
        var contractRec     = component.get("v.contractConfigRec")[listIndex];
        if(contractRec.Status__c != $A.get("$Label.c.Mapping_Status_Inactive")){
            var action = component.get("c.deactivateContract");
            action.setParams({
                "contractId" : contractRec.Id
            });
   //         debugger;
            action.setCallback(this, function(response) {
                var res     = response.getReturnValue();
                res         = "<b>" + res + "</b>";
                component.set("v.activateModalMsg", res); 
                document.getElementById("ActivateMappingConfigurationModal").style.display = "block" ;
            });
            $A.enqueueAction(action);
        }else{
            var message = $A.get("$Label.c.Record_already_Inactive_Err_Msg");
            component.set("v.activateModalMsg", message); 
            document.getElementById("ActivateMappingConfigurationModal").style.display = "block" ;
        }
   //     debugger;
    },
    
    
    copyContract : function(component, event, helper, listIndex){
        var contractRec 	= component.get("v.contractConfigRec")[listIndex];
        component.set("v.typeSelForCopy", contractRec.Type__c);
        component.set("v.subTypeSelForCopy", contractRec.SubType__c);
        component.set("v.selContractConfigId", contractRec.Id);
        document.getElementById("CopyConfigurationModel").style.display = "block" ;
    },
    
    
    validateAndCopyMapping : function(component, event, helper){
        this.validateCopy(component, event, helper);
    },
    
    
    validateCopy : function(component, event, helper){
      	var typeSel 		= component.get("v.typeSelectedValue");
        var subTypeSel		= component.get("v.subTypeSelectedValue");
        var typeSelCopy 	= component.get("v.typeSelForCopy");
        var subTypeSelCopy	= component.get("v.subTypeSelForCopy");
        var isErrorFound	= false;
        var errMessage		= '';
        if(typeSel == undefined || typeSel == ''){
			isErrorFound 	= true;            
            errMessage		= $A.get("$Label.c.Select_Type_Err_Msg_Copy_Config");
        }else{
            if(typeSelCopy == typeSel && subTypeSelCopy == subTypeSel){
                isErrorFound 	= true;
                errMessage 		= $A.get("$Label.c.Select_Diff_Type_Subtype_Err_Msg_Copy_Config")
            }
        }
        
        if(isErrorFound){
   //         debugger;
            component.set("v.isErrorInCopyMapping", true);
            component.set("v.copyModalMsg", errMessage);
            document.getElementById("CopyMappingSubmitErrMsgModel").style.display = "block" ;
        }else{
            var action = component.get("c.copyContract");
            action.setParams({
    	        "contractId" : component.get("v.selContractConfigId"),
                "selType" 	 : typeSel,
                "selSubType" : subTypeSel,
	        });
            action.setCallback(this, function(response) {
                var res 	= response.getReturnValue();
                if(res = $A.get("$Label.c.Success_return_message")){
                    component.set("v.isErrorInCopyMapping", false);
                }else{
                    component.set("v.isErrorInCopyMapping", true);
                }
                component.set("v.copyModalMsg", res);
                document.getElementById("CopyMappingSubmitErrMsgModel").style.display = "block" ;
            });
            $A.enqueueAction(action);
        }
    },
    
    
    deleteContract : function(component, event, helper, listIndex){
        var contractRec 	= component.get("v.contractConfigRec")[listIndex];
        component.set("v.deleteRecId", contractRec.Id);
        document.getElementById("DeleteMappingConfigurationModal").style.display = "block" ;
    },
    
    
    onDeleteModalConfirm : function(component, event, helper) {
        document.getElementById("DeleteMappingConfigurationModal").style.display = "none" ;
        var action = component.get("c.deleteContract");
            action.setParams({
    	        "contractId" : component.get("v.deleteRecId")
	        });
    //        debugger;
            action.setCallback(this, function(response) {
                var res 	= response.getReturnValue();
                component.set("v.deleteModalMsg", res); 
                document.getElementById("DeleteRespMappingConfigurationModal").style.display = "block" ;
            });
            $A.enqueueAction(action);
    },
    
    
    onReview : function(component, event, helper){
    //    debugger;
        var listIndex		= event.getSource().get("v.value");
		var contractRec 	= component.get("v.contractConfigRec")[listIndex];
		var cmpEvent 		= component.getEvent("fetchMDataEvent");
        cmpEvent.setParams({
            "showMapping" : true , 
        	"controllingFieldValue" : contractRec.Type__c ,
            "dependentFieldValue" : contractRec.SubType__c
        });
        cmpEvent.fire();        
    },


    sortTypeDESC : function(component, event, helper){
  //      debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.Type__c.toLowerCase();
            var y = b.Type__c.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
  //      debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortTypeASC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.Type__c.toLowerCase();
            var y = b.Type__c.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortSubTypeDESC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.SubType__c.toLowerCase();
            var y = b.SubType__c.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortSubTypeASC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.SubType__c.toLowerCase();
            var y = b.SubType__c.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortStatusDESC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            if(a.Status__c == undefined) return 1;
            if(b.Status__c == undefined) return -1;
            var x = a.Status__c.toLowerCase();
            var y = b.Status__c.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortStatusASC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            if(a.Status__c == undefined) return -1;
            if(b.Status__c == undefined) return 1;
            var x = a.Status__c.toLowerCase();
            var y = b.Status__c.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortCreatedByDESC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.CreatedBy.Name.toLowerCase();
            var y = b.CreatedBy.Name.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortCreatedByASC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.CreatedBy.Name.toLowerCase();
            var y = b.CreatedBy.Name.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortUpdatedOnDESC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.LastModifiedDate.toLowerCase();
            var y = b.LastModifiedDate.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    sortUpdatedOnASC : function(component, event, helper){
   //     debugger;
        var configListToSort    = component.get("v.contractConfigRec");
        configListToSort.sort(function(a,b) {
            var x = a.LastModifiedDate.toLowerCase();
            var y = b.LastModifiedDate.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
   //     debugger;
        component.set("v.contractConfigRec", configListToSort);
    },


    closeCopyErrModal : function(component, event, helper){
        document.getElementById("CopyMappingSubmitErrMsgModel").style.display = "none" ;
        if(!component.get("v.isErrorInCopyMapping")){
   //         debugger;
            document.getElementById("CopyConfigurationModel").style.display = "none" ;
            try{
                $A.get('e.force:refreshView').fire();    
            }catch(e){
                location.reload();
            }
            
        }
    },


    onDeleteResModalConfirm : function(component, event, helper) {
        document.getElementById("DeleteRespMappingConfigurationModal").style.display = "none" ;
        try{
            $A.get('e.force:refreshView').fire();    
        }catch(e){
            location.reload();   
        }
        
    },


    onActivateModalConfirm : function(component, event, helper) {
   //     debugger;
        var message     = component.get("v.activateModalMsg");
        if(message == "<b>SUCCESS</b>"){
            document.getElementById("ActivateMappingConfigurationModal").style.display = "none" ;
            try{
                $A.get('e.force:refreshView').fire();
            }catch(e){
               location.reload();   
            }
            
        }
        document.getElementById("ActivateMappingConfigurationModal").style.display = "none" ;
    }
})