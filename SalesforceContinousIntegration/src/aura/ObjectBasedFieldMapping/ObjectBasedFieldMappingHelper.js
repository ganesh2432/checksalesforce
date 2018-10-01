({
	doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        this.getObjectDetails(component, event, helper);
        component.set("v.Spinner", false);
	},


    onSelectChangeTableOne : function(component, event, helper) {
        var selectedObject=component.find("selectedObjFromFirstTable").get("v.value");
        component.set("v.firstSelectedObject",selectedObject);
        if(component.find("selectedObjFromFirstTable").get("v.value") == component.find("selectedObjFromSecondTable").get("v.value")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select different object"
            });
            toastEvent.fire();
            component.set("v.firstFieldList",[]);
        }else{
            var opts = [{ "class": "optionClass", label: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), selected: "true" }];
            var firstFieldList = component.get("c.getFieldsDetailsForParticularObject");
            firstFieldList.setParams({"ObjectLable":selectedObject});
            firstFieldList.setCallback(this,function(response){
                var fieldList = response.getReturnValue();
                
                for(var i=0;i<fieldList.length;i++){
                    opts.push({"class": "optionClass", label: fieldList[i], value: fieldList[i], selected: "false" });
                } 
                opts.push({"class": "optionClass", label: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), selected: "false" });
                component.find("InputSelectDynamicList1").set("v.options", opts);
            });       
            $A.enqueueAction(firstFieldList);     
        }
    },
    

    onSelectChangeTabletwo : function(component, event, helper) {    
        var selectedObject=component.find("selectedObjFromSecondTable").get("v.value");
        component.set("v.secondSelectedObject",selectedObject);
        if(component.find("selectedObjFromFirstTable").get("v.value") == component.find("selectedObjFromSecondTable").get("v.value")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select different object"
            });
            toastEvent.fire();
            component.set("v.secondFieldList",[]);
        }else{
            var opts = [{ "class": "optionClass", label: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), selected: "true" }];
             
            var secondFieldList = component.get("c.getFieldsDetailsForParticularObject");
            secondFieldList.setParams({"ObjectLable":selectedObject});
            secondFieldList.setCallback(this,function(response){
                var fieldList = response.getReturnValue();
                for(var i=0;i<fieldList.length;i++){
                    opts.push({"class": "optionClass", label: fieldList[i], value: fieldList[i], selected: "false" });
                }
                opts.push({"class": "optionClass", label: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), selected: "false" });
                component.find("InputSelectDynamicList2").set("v.options", opts);
                
            });       
            $A.enqueueAction(secondFieldList);       
        }
    },
    

    getIContractsData : function(component, event, helper){
        component.set("v.Spinner", true);
        var action 		= component.get("c.getMetadataRecords");
        var configId 	= component.get("v.mapConfigId");
        action.setParams({
            	"mapConfigId" : configId
	        });
        action.setCallback(this, function(response) {
            var res 		= response.getReturnValue();
            component.set("v.iContractMetadataMap",res);
            var object1List = component.get("v.object1List");
            var object2List = component.get("v.object2List");
            var recToSave = [];
            for(var key in res){
                var sot = false;
                if(res[key].SOT__c == 'Salesforce') sot = true;
                recToSave.push({ "fieldName"        : res[key].Field_Name__c, 
                                 "displayName"      : res[key].Display_Name__c,
                                 "dataType"         : res[key].DataType__c,
                                 "mappingField1"    : "",
                                 "mappingField2"    : "",
                                 "sot"              : sot});
            }
            debugger;
            component.set("v.SelectedFieldsFromIcontract", recToSave);
            if(object1List.length == 1) {
                component.set("v.object1Str",object1List[0]);
                this.firstObjectFields(component, event, helper);
            }
            if(object2List.length == 1) {
                component.set("v.object2Str",object2List[0]);
                this.secondObjectFields(component, event, helper);
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    
    getObjectDetails :function(component, event, helper){
        var objectDetails = component.get("c.getObjectsToMapFromCM");
        objectDetails.setCallback(this, function(response) {
            var objectMap = response.getReturnValue();
            var object1List = [];
            var object2List = [];
            for(var key in objectMap){
                if(key == "Object 1"){
                    var val = objectMap[key];
                    for(var i = 0; i < val.length; i ++){
                        object1List.push(val[i]);
                    }
                     
                }
                if(key == "Object 2"){
                    var val = objectMap[key];
                    for(var i = 0; i < val.length; i ++){
                        object2List.push(val[i]);
                    }
                }
            }
            component.set("v.object1List", object1List);
            component.set("v.object2List", object2List);
            this.getContractAndSFFieldDataTypeMapping(component, event, helper);
        })
        $A.enqueueAction(objectDetails);
    },
    
    
    firstObjectFields : function(component, event, helper) {
		var objectDetails 	= component.get("c.getFieldsDetailsForParticularObject");
        var obj 			= component.get("v.object1Str");
        var obj1Map = {};
        objectDetails.setParams({"ObjectLable":obj});
        objectDetails.setCallback(this, function(response) {
            var res 		= response.getReturnValue();
            var index = 0;
            var opts = [{ "class": "optionClass", index : "0" ,label: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Select_Field_Object_Mapping_Component") }];
            for(var key in res){
                    opts.push({"class": "optionClass", label: res[key].fieldLabel , value: key});
                }
            opts.push({"class": "optionClass", label: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")});
            var metadataMap = component.get("v.iContractMetadataMap");
       //     component.set("v.object1Fields", opts);
            var recToSave = component.get("v.SelectedFieldsFromIcontract");
            for(var i = 0; i < recToSave.length ; i++){
            	recToSave[i].mappingField1 	= metadataMap[recToSave[i].fieldName].Mapping_Field__c;
            }
            component.set("v.SelectedFieldsFromIcontract", recToSave);
            component.set("v.object1Map", res);
            var map1 = component.get("v.object1Map");
            this.prepareFirstObjIContAndSFFieldList(component, event, helper);                
        });
        $A.enqueueAction(objectDetails);
    },


    prepareFirstObjIContAndSFFieldList : function(component, event, helper){
        var  recToSave              = component.get("v.SelectedFieldsFromIcontract");
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

            obj1WithDataTypeList.sort(function(a,b) {
                if(a.label == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                return 1;  
            }
            var x = a.label.toLowerCase();
            var y = b.label.toLowerCase();             
            if (x < y ) {return -1;}
            if (x > y ) {return 1;}
            return 0;
            });
            
        }

        component.set("v.obj1WithDataTypeList", obj1WithDataTypeList);
    },
    
    
    secondObjectFields : function(component, event, helper) {
		var objectDetails 	= component.get("c.getFieldsDetailsForParticularObject");
        var obj 			= component.get("v.object2Str");
        var obj2Map = {};
        objectDetails.setParams({"ObjectLable":obj});
        objectDetails.setCallback(this, function(response) {
            var res 		= response.getReturnValue();
            var opts = [{ "class": "optionClass", label: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Select_Field_Object_Mapping_Component"), selected: "true" }];
            for(var key in res){
                    opts.push({"class": "optionClass", label: res[key].fieldLabel, value: key, selected: "false" });
                }
            opts.push({"class": "optionClass", label: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), value: $A.get("$Label.c.Create_New_Field_Object_Mapping_Component"), selected: "false" });
            var metadataMap = component.get("v.iContractMetadataMap");
        //    component.set("v.object2Fields", opts);
            var recToSave = component.get("v.SelectedFieldsFromIcontract");
            
            for(var i = 0; i < recToSave.length ; i++){
            	recToSave[i].mappingField2	= metadataMap[recToSave[i].fieldName].Mapping_Field_2__c;
            }
			component.set("v.SelectedFieldsFromIcontract", recToSave);
            component.set("v.object2Map", res);
            this.prepareSecondObjIContAndSFFieldList(component, event, helper);
        });
        $A.enqueueAction(objectDetails);
    },


    prepareSecondObjIContAndSFFieldList : function(component, event, helper){
        var recToSave               = component.get("v.SelectedFieldsFromIcontract");
        var obj2Map                 = component.get("v.object2Map");
        var fieldTypeMap            = component.get("v.fieldDataTypeMap");
        var obj2WithDataTypeList    = [];
        for (var i = 0; i < recToSave.length; i++) {
            obj2WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": $A.get("$Label.c.Select_Field_Object_Mapping_Component") , "salesforceField": $A.get("$Label.c.Select_Field_Object_Mapping_Component")});
            var iContractDataType = fieldTypeMap[recToSave[i].dataType];
            for(var key in obj2Map){
                if(iContractDataType.includes(obj2Map[key].fieldType)){
                    obj2WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": obj2Map[key].fieldLabel , "salesforceField": key});
                }
            }
            obj2WithDataTypeList.push({"iContractField": recToSave[i].fieldName, "label": $A.get("$Label.c.Create_New_Field_Object_Mapping_Component") , "salesforceField": $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")});
            obj2WithDataTypeList.sort(function(a,b) {
                if(a.label == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                return 1;  
            }
            var x = a.label.toLowerCase();
            var y = b.label.toLowerCase();             
            if (x < y ) {return -1;}
            if (x > y ) {return 1;}
            return 0;
            });
        }

        component.set("v.obj2WithDataTypeList", obj2WithDataTypeList);
    },
    
    
    getContractAndSFFieldDataTypeMapping : function(component, event, helper) {
        var objectDetails = component.get("c.getContractAndSFFieldDataTypeMapping");
        objectDetails.setCallback(this, function(response) {
            var objectMap = response.getReturnValue();
            component.set("v.fieldDataTypeMap",objectMap);
            this.getIContractsData(component, event, helper);    
        })
        $A.enqueueAction(objectDetails);
    },
    
    
    onFieldSelectObj : function(component, event, helper){
        var selValue = event.getSource().get("v.value");
        if(selValue == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
            component.set("v.newFieldCreateObj", component.get("v.object1Str"));
        	document.getElementById("ExitConfigurationModelObjMap").style.display = "block" ;     
        }
    },
    
    
    onFieldSelectSecObj : function(component, event, helper){
        var selValue = event.getSource().get("v.value");
        if(selValue == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
            component.set("v.newFieldCreateObj", component.get("v.object2Str"));
        	document.getElementById("ExitConfigurationModelObjMap").style.display = "block" ;     
        }
    },
    
    
    onModalCancel : function(component, event, helper){
        var allRecsToBeSaved        = component.get("v.SelectedFieldsFromIcontract");
        for(var i = 0; i < allRecsToBeSaved.length; i++){
            if(allRecsToBeSaved[i].mappingField1 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField1   = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
            }
            if(allRecsToBeSaved[i].mappingField2 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField2   = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
            }
        }
        component.set("v.SelectedFieldsFromIcontract", allRecsToBeSaved);
        document.getElementById("ExitConfigurationModelObjMap").style.display = "none" ;
    },
    
    
    onFieldMismatchModalCancel : function(component, event, helper){
        var allRecsToBeSaved        = component.get("v.SelectedFieldsFromIcontract");
        for(var i = 0; i < allRecsToBeSaved.length; i++){
            if(allRecsToBeSaved[i].mappingField1 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField1   = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
            }
            if(allRecsToBeSaved[i].mappingField2 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField2   = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
            }
        }
        component.set("v.SelectedFieldsFromIcontract", allRecsToBeSaved);
        document.getElementById("FieldMismatchErrorMessageModal").style.display = "none" ;
    },
    
    
    onModalConfirm : function(component, event, helper){
        component.set("v.isNewFieldCreate", true);
        this.saveObjectMapping(component, event, helper);
    },
    
    
    onModalConfirmAfterSave : function(component, event, helper){
        var objectDetails 	= component.get("c.getObjectFieldSetUpURL");
        var obj 			= component.get("v.newFieldCreateObj");
        var themeURL        = component.get("v.themeURL");
        objectDetails.setParams({"objectName":obj, "urlTheme" : themeURL});
        objectDetails.setCallback(this, function(response) {
            var urlEvent = $A.get("e.force:navigateToURL");
            if(urlEvent != undefined){
            	urlEvent.setParams({
                "url": response.getReturnValue()
            	});
            	urlEvent.fire();    
            }else{
                window.open(response.getReturnValue(), "_parent");

            }
            
        });
        $A.enqueueAction(objectDetails);
    },
    
    
    saveObjectMapping : function(component, event, helper) {
        component.set("v.Spinner", true);
        var allRecsToBeSaved 		= component.get("v.SelectedFieldsFromIcontract");
        var obj1Map			 		= component.get("v.object1Map");
        var obj2Map			 		= component.get("v.object2Map");
        var fieldTypeMap	 		= component.get("v.fieldDataTypeMap");
        var isFieldMismatchFound 	= false;
        var isContractFieldEmpty    = false;
        var errMessage              = '';
        var object1FieldValueArr    = [];
        var object2FieldValueArr    = [];
        var duplicateFieldMatchErrMsg   = '';
        var isDuplicateFieldMatchFound  = false; 
        var object1                     = component.get("v.object1Str");
        var object2                     = component.get("v.object2Str");
        var errSeq                      = 1;
        for(var i = 0; i < allRecsToBeSaved.length; i++){
            var salesforceF1DataType = undefined;
            var salesforceF2DataType = undefined;
            var mappingTypeFields 	 = undefined; 
            var iContractDataType 	 = allRecsToBeSaved[i].dataType;
            if(allRecsToBeSaved[i].sot == true){
                allRecsToBeSaved[i].sot     = 'Salesforce';
            }else{
                allRecsToBeSaved[i].sot     = 'iContract';
            }
            if(allRecsToBeSaved[i].mappingField1 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component") || allRecsToBeSaved[i].mappingField1 == $A.get("$Label.c.Select_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField1	= undefined;
            }
            if(allRecsToBeSaved[i].mappingField2 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component") || allRecsToBeSaved[i].mappingField2 == $A.get("$Label.c.Select_Field_Object_Mapping_Component")){
                allRecsToBeSaved[i].mappingField2	= undefined;
            }
            object1FieldValueArr.push(allRecsToBeSaved[i].mappingField1);
            object2FieldValueArr.push(allRecsToBeSaved[i].mappingField2);
            
            if((iContractDataType.includes('enum') || iContractDataType.includes('ENUM')) && !iContractDataType.includes('enumradio')){
                iContractDataType = 'enum';
            }

            if(allRecsToBeSaved[i].mappingField1   == undefined){
                isContractFieldEmpty    = true;
            }

            if(obj1Map[allRecsToBeSaved[i].mappingField1] != undefined)
            salesforceF1DataType	= obj1Map[allRecsToBeSaved[i].mappingField1].fieldType;
            if(obj2Map[allRecsToBeSaved[i].mappingField2] != undefined)
            salesforceF2DataType	= obj2Map[allRecsToBeSaved[i].mappingField2].fieldType;
            mappingTypeFields 		= fieldTypeMap[iContractDataType];
            if(mappingTypeFields != undefined){
                var isError = false;
                if(salesforceF1DataType != undefined){
                    if(!mappingTypeFields.includes(salesforceF1DataType)){
                        isFieldMismatchFound = true;
                        isError 			 = true;
                    }    
                }
                if(salesforceF2DataType != undefined){
                    if(!mappingTypeFields.includes(salesforceF2DataType)){
                        isFieldMismatchFound = true;
                        isError 			 = true;
                    }    
                }
                if(isError){
                    errMessage = errMessage + ' <br/> <b>' + allRecsToBeSaved[i].displayName + ' : </b>Field datatype mismatch found.'; 
                }
            }
        }

        for(var i = 0; i < allRecsToBeSaved.length; i++){
            if(allRecsToBeSaved[i].mappingField1 != undefined){
                if(object1FieldValueArr.indexOf(allRecsToBeSaved[i].mappingField1) != object1FieldValueArr.lastIndexOf(allRecsToBeSaved[i].mappingField1)){
                    isDuplicateFieldMatchFound = true;
                    duplicateFieldMatchErrMsg  += '<b>' + errSeq + ': </b>' +'Duplicate field match found in ' + object1 + ' at Sr. No. '+ (i +1) + '<br/>';
                    errSeq++;
                }
            }
            if(allRecsToBeSaved[i].mappingField2 != undefined){
                if(object2FieldValueArr.indexOf(allRecsToBeSaved[i].mappingField2) != object2FieldValueArr.lastIndexOf(allRecsToBeSaved[i].mappingField2)){
                    isDuplicateFieldMatchFound = true;
                    duplicateFieldMatchErrMsg  += '<b>' + errSeq + ': </b>' +'Duplicate field match found in ' + object2 + ' at Sr. No. '+ (i +1) + '<br/>';
                    errSeq++;   
                }   
            }

        }
//        isDuplicateFieldMatchFound = false;
//        isFieldMismatchFound       = false;
//        isContractFieldEmpty       = false;
        if(isDuplicateFieldMatchFound){
            for(var i = 0; i < allRecsToBeSaved.length; i++){
                if(allRecsToBeSaved[i].mappingField1 == undefined){
                    allRecsToBeSaved[i].mappingField1	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                }
                if(allRecsToBeSaved[i].mappingField2 == undefined){
                    allRecsToBeSaved[i].mappingField2	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                } 
            }
            
            component.set("v.Spinner", false);
            component.set("v.fieldMismatchErrMsg", duplicateFieldMatchErrMsg);
            document.getElementById("ExitConfigurationModelObjMap").style.display = "none" ;     
            document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
        }
        else if(isFieldMismatchFound){
            for(var i = 0; i < allRecsToBeSaved.length; i++){
                if(allRecsToBeSaved[i].mappingField1 == undefined){
                    allRecsToBeSaved[i].mappingField1	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                }
                if(allRecsToBeSaved[i].mappingField2 == undefined){
                    allRecsToBeSaved[i].mappingField2	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                } 
            }
            
            component.set("v.Spinner", false);
            component.set("v.fieldMismatchErrMsg", errMessage);
            document.getElementById("ExitConfigurationModelObjMap").style.display = "none" ;     
			document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;            
        }else if(isContractFieldEmpty && !component.get("v.isNewFieldCreate")){
            for(var i = 0; i < allRecsToBeSaved.length; i++){
                if(allRecsToBeSaved[i].mappingField1 == undefined){
                    allRecsToBeSaved[i].mappingField1	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                }
                if(allRecsToBeSaved[i].mappingField2 == undefined){
                    allRecsToBeSaved[i].mappingField2	= $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                } 
            }
            
            component.set("v.Spinner", false);
            component.set("v.fieldMismatchErrMsg", '<b>Mapping of all fields to Salesforce Contract Object is mandatory.</b>');
            document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
        }else{
            var action = component.get("c.saveIcontractRecords");
        	action.setParams({
            	"recordList"  : JSON.stringify(allRecsToBeSaved),
            	"mapConfigId" : component.get("v.mapConfigId"),
                "object1"     : object1,
                "object2"     : object2
	        });
    	    action.setCallback(this,function(response){
                component.set("v.Spinner", false);
        	    if(component.get("v.isNewFieldCreate")){
            	   this.onModalConfirmAfterSave(component, event, helper);
        		}else{
                    if(response.getReturnValue() == "SUCCESS"){
                        var successMsg  = "<b>"+response.getReturnValue()+"</b>";
                        component.set("v.fieldMatchSaveMsg", successMsg);
                        component.get("v.fieldMatchSaveMsg");
                        var compEvent = $A.get("e.c:MovetoNextProgressBarEvt");
                        compEvent.setParams({"movetoStep" : "step3", "mappingConfigId" : component.get("{!v.mapConfigId}")})                
                        compEvent.fire();
                    }else{
                        component.set("v.fieldMismatchErrMsg", response.getReturnValue());
                        document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
                    }
    			}
			});       
        	$A.enqueueAction(action);  
        }
    },


    onSuccessModalClick : function(component, event, helper){
        var compEvent = $A.get("e.c:MovetoNextProgressBarEvt");
        compEvent.setParams({"movetoStep" : "step3", "mappingConfigId" : component.get("{!v.mapConfigId}")})                
        compEvent.fire();
    }
})