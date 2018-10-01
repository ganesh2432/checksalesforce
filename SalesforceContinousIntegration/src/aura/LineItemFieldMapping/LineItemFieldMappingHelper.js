({
	doInit : function(component, event, helper) {
        component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :true}).fire();                                         
        //call getExistingLineItemData and iterate and set values                                         
        var action 	= component.get("c.getExistingLineItemData");
        action.setParams({"isItFromComponent":true});
        
        action.setCallback(this, function(response) {
            var res 		= response.getReturnValue();
            
            var fieldMap = {};
            var sotMap = {};
            
            for(var i=0;i<res.length;i++){
                var sotSalesforce = false;
                if(res[i].SOT__c == 'Salesforce'){
                    sotSalesforce = true;
                }
            	fieldMap[res[i].Field_Name__c] = res[i].Mapping_Field__c;
                sotMap[res[i].Field_Name__c] = sotSalesforce;
              }
            
            var selectedLineItemData = component.get("v.lineItemData");
            for(var i =0;i<selectedLineItemData.length;i++){
                
                if(selectedLineItemData[i].SOT == undefined){
                    selectedLineItemData[i].SOT = false;
                }
                if(selectedLineItemData[i].fieldName in fieldMap) { 
                    selectedLineItemData[i].mappingField1 = fieldMap[selectedLineItemData[i].fieldName];
                    if(selectedLineItemData[i].mappingField1 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                    selectedLineItemData[i].mappingField1 = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                    }
                }
                if(selectedLineItemData[i].fieldName in sotMap) { 
                    selectedLineItemData[i].SOT = sotMap[selectedLineItemData[i].fieldName];
                 }
            }
            component.set("v.lineItemData",selectedLineItemData);
               
        });
        $A.enqueueAction(action);                                        
                                                 
        var objectDetails = component.get("c.getObjectNameForLineItemMapping");
                                                 
        objectDetails.setCallback(this, function(response) {
            var lineItemObject = response.getReturnValue();
            if (response.getState() == "SUCCESS") {
				component.set("v.objectName",lineItemObject.MasterLabel);
                helper.ObjectFields(component, event, helper);
                //setTimeout(function(){}, 3000); 
                
               }
        })
        $A.enqueueAction(objectDetails);   
                                                 
	},  
    
    ObjectFields : function(component, event, helper) {
		var action 	= component.get("c.getFieldsDetailsForParticularObject");
        var obj 			= component.get("v.objectName");
        var obj1Map = {};
        
        action.setParams({"ObjectLable":obj});
        
        action.setCallback(this, function(response) {
            var res 		= response.getReturnValue();
            var index = 0;
            var opts = [{ "class": "optionClass", index : "0" ,label: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Select_Field_Object_Mapping_Component") }];
            for(var key in res){
                    opts.push({"class": "optionClass", label: res[key].fieldLabel , value: key});
                }
            opts.push({"class": "optionClass", label: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")});
            component.set("v.object1Fields", opts);

            component.set("v.object1Map", res);
             this.getContractAndSFFieldDataTypeMapping(component, event, helper);   
        });
        $A.enqueueAction(action);
    },
    
    // to get field name with datatype
    getContractAndSFFieldDataTypeMapping : function(component, event, helper) {
        var objectDetails = component.get("c.getContractAndSFFieldDataTypeMapping");
        objectDetails.setCallback(this, function(response) {
            var objectMap = response.getReturnValue();
            component.set("v.fieldDataTypeMap",objectMap);
            
            this.prepareFirstObjIContAndSFFieldList(component,event,helper);
        })
        $A.enqueueAction(objectDetails);
    },
    
    saveRecords : function(component, event, helper){
       component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :true}).fire();
        var allRecsToBeSaved 		= component.get("v.lineItemData");
        var obj1Map			 		= component.get("v.object1Map");
        var fieldTypeMap	 		= component.get("v.fieldDataTypeMap");
        var isFieldMismatchFound 	= false;
        var errMessage = '';
        var j=1;
        var errMessageForUnselectedField = '';
        var k=1;
        var unselectedField = false;
        var duplicateFieldSelectCheck = [];
        var errMessageDuplicate = '';
        var duplicateCheck= false;
        var h=1;
        var passFieldsToNextPage = [];
        for(var i = 0; i < allRecsToBeSaved.length; i++){
            passFieldsToNextPage.push(allRecsToBeSaved[i]);
            allRecsToBeSaved[i].mappingObject = component.get("v.objectName");
            if(allRecsToBeSaved[i].SOT != true){
                    allRecsToBeSaved[i].SOT = false;
            }
            
            //duplicate field mapping check
            if(allRecsToBeSaved[i].mappingField1 != $A.get("$Label.c.Select_Field_Object_Mapping_Component") && allRecsToBeSaved[i].mappingField1 != "" && allRecsToBeSaved[i].mappingField1 != undefined && !duplicateFieldSelectCheck.includes(allRecsToBeSaved[i].mappingField1)){
                duplicateFieldSelectCheck.push(allRecsToBeSaved[i].mappingField1);
            }else{
                if(allRecsToBeSaved[i].mappingField1 != "" && allRecsToBeSaved[i].mappingField1 != 'Select Field' && allRecsToBeSaved[i].mappingField1 != undefined){
                errMessageDuplicate = '<center>'+errMessageDuplicate +(h)+': ' + allRecsToBeSaved[i].displayName+'</center><br/>'; 
                h = h+1;
                duplicateCheck = true;
                }
            }
            
            // check for unselected fields
            if(allRecsToBeSaved[i].mappingField1 == "" || allRecsToBeSaved[i].mappingField1 == undefined || allRecsToBeSaved[i].mappingField1 == 'Select Field'){
                errMessageForUnselectedField = '<center>'+errMessageForUnselectedField +(k)+': ' + allRecsToBeSaved[i].displayName+'</center><br/>'; 
                k = k+1;
                unselectedField = true;
            }
            
            var salesforceF1DataType = undefined;
            var mappingTypeFields 	 = undefined; 
            var iContractDataType 		= allRecsToBeSaved[i].dataType;
            if((iContractDataType.includes('enum') || iContractDataType.includes('ENUM')) && !iContractDataType.includes('enumradio')){
                iContractDataType = 'enum';
            }
            if(obj1Map[allRecsToBeSaved[i].mappingField1] != undefined)
            salesforceF1DataType	= obj1Map[allRecsToBeSaved[i].mappingField1].fieldType;
            mappingTypeFields 		= fieldTypeMap[iContractDataType];
            if(mappingTypeFields != undefined){
                var isError = false;
                if(salesforceF1DataType != undefined){
                    if(!mappingTypeFields.includes(salesforceF1DataType)){
                        isFieldMismatchFound = true;
                        isError 			 = true;
                    }    
                }
                if(isError){
                    errMessage = '<center>'+errMessage +(j)+': ' + allRecsToBeSaved[i].displayName+'</center><br/>'; 
                    j = j+1;
                }
            }
        }

        //duplicate field mapping check
        if(duplicateCheck && !component.get("v.isNewFieldCreate")){
           if(h==2){
              errMessageDuplicate = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_duplicate_field_Mapped")+'</b></center><br/>' + errMessageDuplicate;  
            }else{
              errMessageDuplicate = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_duplicate_fields_Mapped")+'</b></center><br/>' + errMessageDuplicate;  
            }
            component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            component.set("v.fieldMismatchErrMsg", errMessageDuplicate);
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ; 
        }else{
        if(unselectedField && !component.get("v.isNewFieldCreate")){// check for unselected fields
            if(k==2){
                errMessageForUnselectedField = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_unmapped_field_error_message")+'</b></center><br/>' + errMessageForUnselectedField;
            }else{
                errMessageForUnselectedField = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.LineItem_unmapped_fields_error_message")+'</b></center><br/>' + errMessageForUnselectedField;
            }
            component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            component.set("v.fieldMismatchErrMsg", errMessageForUnselectedField);
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;return;
        }else{
        
        if(isFieldMismatchFound && !component.get("v.isNewFieldCreate")){
            if(j==1){
                errMessage = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_field_data_type_mismatch")+'</b></center><br/>' + errMessage;
            }else{
                errMessage = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Line_item_fields_data_type_mismatch")+'</b></center><br/>' + errMessage;
            }
            component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
            component.set("v.fieldMismatchErrMsg", errMessage);
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;   return;         
        }else{
            // to save mapping of line item fields
            var mappedRecordsToSave = JSON.stringify(allRecsToBeSaved);
            var action = component.get("c.mappingObjectFieldForLineItemSelectedFields");  
            action.setParams({
                "mappedFieldsData": mappedRecordsToSave
            }); 
        
            action.setCallback(this, function(response) {
            var existingLineItemDataforMappedfields = response.getReturnValue();
            var state = response.getState();
            
            if(state == 'SUCCESS' && existingLineItemDataforMappedfields!='Exception'){
                
                if(component.get("v.isNewFieldCreate")){debugger;
                    this.onModalConfirmAfterSave(component, event, helper);
                }else{
                component.getEvent("LineItemMappingThirdPage").setParams({"movetoStep" : "step3", "fieldsForValueMapping" : passFieldsToNextPage}).fire();//redirecting to 3rd step
                }
                }// add else to show opps something went wrong
            
        });
        $A.enqueueAction(action);
        }
        }
    }   
    }
    ,
    // to redirect for field creation salesforce page on clik of create new field
    onModalConfirmAfterSave : function(component, event, helper){
        var objectDetails 	= component.get("c.getObjectFieldSetUpURL");
        var obj 			= 'OpportunityLineItem';
        var themeURL        = component.get("v.themeURL");
        objectDetails.setParams({"objectName":obj, "urlTheme" : themeURL});
        objectDetails.setCallback(this, function(response) {
            //console.log(window.location.href);
            var urlEvent = $A.get("e.force:navigateToURL");
            if(urlEvent != undefined){console.log(response.getReturnValue());
            	urlEvent.setParams({
                "url": response.getReturnValue()
            	});
            	urlEvent.fire();    
            }else{
                window.open(response.getReturnValue(), "_parent");
            }
            //component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire(); //not stopped the spinner. because anyways it will leave the component so instead of displaying model for 1sec/2sec during slow internet once spiiner is false. let it keeep spiining untill it redirects to another page
        });
        $A.enqueueAction(objectDetails);
    },

	// for filtering fields based on datatypes
    prepareFirstObjIContAndSFFieldList : function(component, event, helper){
        var  recToSave              = component.get("v.lineItemData");
        var obj1Map                 = component.get("v.object1Map");
        var fieldTypeMap            = component.get("v.fieldDataTypeMap");
        var obj1WithDataTypeList    = [];
        for (var i = 0; i < recToSave.length; i++) {
            obj1WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": $A.get("$Label.c.Select_Field_Object_Mapping_Component") , "salesforceField": $A.get("$Label.c.Select_Field_Object_Mapping_Component")});
            var iContractDataType = fieldTypeMap[recToSave[i].dataType];
            for(var key in obj1Map){
                if(iContractDataType.includes(obj1Map[key].fieldType)){
                    obj1WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": obj1Map[key].fieldLabel , "salesforceField": key});
                }
            }
            obj1WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": $A.get("$Label.c.Create_New_Field_Object_Mapping_Component") , "salesforceField": $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")});
        }

        component.set("v.obj1WithDataTypeList", obj1WithDataTypeList);
        component.getEvent("LineItemMappingSpinnerEvent").setParams({"spin" :false}).fire();
    }
})