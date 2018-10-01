({
    // to get picklist value to map based on fieldname of object
    getFieldBasedIContractValuesAndSalesforceValues : function(component,event,helper,FieldName,mappingField,mappingObj,allowedValuesList) {
        var getSelectedValues = component.get("c.getSelectedFieldsValuesFromIcontractAndSalesforce");
        getSelectedValues.setParams({"ObjectName":mappingObj,
                                     "FieldName":mappingField,
                                     "allowedValues":allowedValuesList,
                                     "fieldNameForExistingCheck":FieldName});
        getSelectedValues.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var fieldPickListValues = response.getReturnValue();   
                var ValueMappingObjectList = [];
                component.set("v.selectedField",FieldName);//merging existing and newly selected fields and displaying for value mapping
                if(fieldPickListValues.existingValueMapping.length<1){
                for(var i=0;i<allowedValuesList.length;i++){
                    ValueMappingObjectList.push({ "sobjectType": "Value_Mapping__c","IContract_Value__c":allowedValuesList[i],"Mapping_Field__c":mappingField,"Mapping_Value__c":"","Mapping_Object__c":mappingObj,"Field_Name__c":FieldName});
                }   
                }else{
                for(var i=0;i<fieldPickListValues.existingValueMapping.length;i++){
                    ValueMappingObjectList.push({ "sobjectType": "Value_Mapping__c","IContract_Value__c":fieldPickListValues.existingValueMapping[i].IContract_Value__c,"Mapping_Field__c":fieldPickListValues.existingValueMapping[i].Mapping_Field__c,"Mapping_Value__c":fieldPickListValues.existingValueMapping[i].Mapping_Value__c,"Mapping_Object__c":fieldPickListValues.existingValueMapping[i].Mapping_Object__c,"Field_Name__c":fieldPickListValues.existingValueMapping[i].Field_Name__c,"Id":fieldPickListValues.existingValueMapping[i].Id});
                }
            }
                component.set("v.pickValueWrapper",ValueMappingObjectList);
                component.set("v.selectedFieldPickListVal",fieldPickListValues.PickListValues);
                component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            }
        });$A.enqueueAction(getSelectedValues);
    },
    //fires on selecting another field to map the value and save in the backend
    onChangeSave : function(component,event,helper,one,two){
        component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :true}).fire();                                                    
        var valueMappingRecords = component.get("v.pickValueWrapper");
        
        var UnselectedValues = '';
        var duplicateCheck= false;
        var h=1;
        var duplicateFieldSelectCheck = [];
        var errMessageDuplicate = '';
        var duplicateCheckValues= false;
        var k = 1;
        for(var i=0;i<valueMappingRecords.length;i++){
            //duplicate value mapped check
            if(valueMappingRecords[i].Mapping_Value__c != 'Select Value' && valueMappingRecords[i].Mapping_Value__c != '' && !duplicateFieldSelectCheck.includes(valueMappingRecords[i].Mapping_Value__c)){
                duplicateFieldSelectCheck.push(valueMappingRecords[i].Mapping_Value__c);
            }else{
                if(valueMappingRecords[i].Mapping_Value__c != "" && valueMappingRecords[i].Mapping_Value__c != 'Select Value'){
                errMessageDuplicate = '<center>'+errMessageDuplicate +(k)+': ' + valueMappingRecords[i].IContract_Value__c+'</center><br/>'; 
                k = k+1;
                duplicateCheckValues = true;
                }
            }
            // unmapped value check
            if(valueMappingRecords[i].Mapping_Value__c == 'Select Value' || valueMappingRecords[i].Mapping_Value__c == '' || valueMappingRecords[i].Mapping_Value__c == 'null' || valueMappingRecords[i].Mapping_Value__c == undefined){
               UnselectedValues = '<center>'+UnselectedValues +(h)+': ' + valueMappingRecords[i].IContract_Value__c+'</center><br/>'; 
               h = h+1;
               duplicateCheck = true; 
            }
        }
        //duplicate value mapped check and displaying fields in model
        if(duplicateCheckValues){
            if(k==2){
              errMessageDuplicate = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_duplicate_value_mapping")+'</b></center><br/>' + errMessageDuplicate;  
            }else{
              errMessageDuplicate = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_duplicate_valuse_mapping")+'</b></center><br/>' + errMessageDuplicate;  
            }
            
            component.set("v.fieldMismatchErrMsg", errMessageDuplicate);
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
            component.set("v.savedSuccessfully",false);
            component.set("v.notFoundAnyError",false);
            component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            return;
        }else{
            component.set("v.notFoundAnyError",true);
        }
        // unmapped value check and displaying fields in model
        if(duplicateCheck){
            if(h==2){
              UnselectedValues = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_unmapped_value_error_msg")+'</b></center><br/>' + UnselectedValues;  
            }else{
              UnselectedValues = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_unmapped_values_error_msg")+'</b></center><br/>' + UnselectedValues;  
            }
            
            component.set("v.fieldMismatchErrMsg", UnselectedValues);
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
            component.set("v.savedSuccessfully",false);
            component.set("v.notFoundAnyError",false);
            component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            return;
        }else{
            component.set("v.notFoundAnyError",true); 
        }
        // saving fucntion call in apex controller
        var saveAction = component.get("c.saveValueMapping");debugger;
        saveAction.setParams({"valueMappingRecords":valueMappingRecords});
        saveAction.setCallback(this,function(response){
            var state = response.getState();

            if(state == "SUCCESS"){
                component.set("v.savedSuccessfully",true);
                if(!component.get("v.dontAllowNextPleaseExit"))
                this.nextPickListCheck(component,event,helper,one,two);//this method is called for changing the style from existing field to next field
            }
            else if(state == "ERROR"){   
                component.set("v.savedSuccessfully",false);
            }   
        });$A.enqueueAction(saveAction); 
    },
    // for highlightning selected field
    nextPickListCheck : function(component,event,helper,one,two){
        if(component.get("v.savedSuccessfully")){
        var enmList = [];
        enmList = component.get("v.iContractFieldsList"); 
        
        var ctr;
        var cval;  
        ctr = one;
        cval = two;             
               var Elements = component.find('main');
               for (var i = 0; i < Elements.length; i++) {
                   var val = Elements[i].getElement().getAttribute('data-value');    
                    if(val != cval){
                        $A.util.removeClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    } else {
                        $A.util.addClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    }
            	}

        
       if(enmList[cval].Display_Name__c != component.get("v.selectedField")){
            component.set("v.selectedField",enmList[cval].Display_Name__c);
            var PickListFields = component.get("v.iContractFieldsList");
             var FieldName  = '';
             var mappingField = '';
             var mappingObj = '';
             var allowedValuesList = '';
           
            for(var i=0;i<PickListFields.length;i++){
                if(PickListFields[i].Display_Name__c == enmList[cval].Display_Name__c){
                    FieldName = PickListFields[i].Display_Name__c;
                    mappingField = PickListFields[i].Mapping_Field__c;
                    mappingObj = PickListFields[i].Mapping_Object__c;
                    allowedValuesList = PickListFields[i].AllowedValues__c.split(',');
                }
            }
           helper.getFieldBasedIContractValuesAndSalesforceValues(component,event,helper,FieldName,mappingField,mappingObj,allowedValuesList);
 
        }else{
           // alert('not entered');
            
        }
         }else{
            
        }
        component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
    }
})