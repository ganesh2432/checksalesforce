({
    //on load function call
	doInit : function(component, event, helper) {debugger;
        component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :true}).fire();
		 var action = component.get("c.getIContractFields");//gets the fields from salesforce which was selected from 1st step and fields mapped in the second step
        action.setCallback(this,function(response){

            var state = response.getState();

            if(state == "SUCCESS"){debugger;
               component.set("v.iContractFieldsList",response.getReturnValue()); 
                var selectedfieldonLoad = component.get("v.iContractFieldsList");
                if(selectedfieldonLoad.length>0){
                var FieldName  = selectedfieldonLoad[0].Display_Name__c;
                var mappingField = selectedfieldonLoad[0].Mapping_Field__c;
                var mappingObj = selectedfieldonLoad[0].Mapping_Object__c;
                var allowedValuesList = selectedfieldonLoad[0].AllowedValues__c.split(',');
                component.set("v.firstVal",true);
                var Elements = component.find('main');                
                $A.util.addClass(Elements[0], "slds-popover slds-nubbin_right-bottom thSelect");
                // to get picklist value to map based on fieldname of object
                helper.getFieldBasedIContractValuesAndSalesforceValues(component,event,helper,FieldName,mappingField,mappingObj,allowedValuesList);
                }else{
                    component.getEvent("EvntToDisableSaveAndFinish").setParams({"isEmpty" :false}).fire();

                }
            }
            else if(state == "ERROR"){             
            }   
        });$A.enqueueAction(action);
                                                   
	},
    //fires on selecting another field to map the value and save in the backend
    onChange : function(component,event,helper){
        var ctr;
        var cval;  
        ctr = event.currentTarget;
        cval = ctr.dataset.value;
        helper.onChangeSave(component,event,helper,ctr,cval);
                                                 
    },
    
    onFieldMismatchModalCancel : function(component, event, helper){
        document.getElementById("FieldMismatchErrorMessageModal").style.display = "none" ;
    },
    saveButtonClick : function(component,event,helper){
        var ctr = 0;
        var cval = 0;  
        component.set("v.dontAllowNextPleaseExit",false);
        helper.onChangeSave(component,event,helper,ctr,cval);
        
        
        if(component.get("v.notFoundAnyError")){
        //confirming all mapping completed before save and exit
        var isAllValueMappingComplete = component.get("c.isAllValueMappingComplete");
        
		isAllValueMappingComplete.setParams({"iConMetadata":component.get("v.iContractFieldsList"),
                                             "isForLineItem":true});
        
		isAllValueMappingComplete.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
               var unMappedFieldList = response.getReturnValue();
                if(unMappedFieldList.length>0){
                    var upmappedFieldErrorMssg= '';
                    for(var i=0;i<unMappedFieldList.length;i++){
                        upmappedFieldErrorMssg = '<center>'+upmappedFieldErrorMssg +(i+1)+': ' + unMappedFieldList[i]+'</center><br/>';
                    }
                    
                    if(unMappedFieldList.length == 1){
                      upmappedFieldErrorMssg = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_incomplete_valuemapping_error_msg")+'</b></center><br/>' + upmappedFieldErrorMssg;  
                    }else{
                      upmappedFieldErrorMssg = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_value_mapping_incomplete_error_msg")+'</b></center><br/>' + upmappedFieldErrorMssg;  
                    }
                    
                    component.set("v.fieldMismatchErrMsg", upmappedFieldErrorMssg);
			        document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
                    
                }else{
                    component.set("v.dontAllowNextPleaseExit",true);//
                    //document.getElementById("lineItemConfirmation").style.display = "block" ;
                    component.getEvent("goToHomePage").fire();
                }
            }
        });$A.enqueueAction(isAllValueMappingComplete);
        }

    },
    CloasePopUpForConfir : function(component, event, helper){
        document.getElementById("lineItemConfirmation").style.display = "none" ;
    },
    yesExitConfig: function(component, event, helper){
        component.getEvent("goToHomePage").fire();
    }
})