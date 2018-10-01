({
    makeRequest : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.service");
        
        action.setCallback(this, function(a) {
             var selType    = component.get("v.selectedType");
             var selSubType    = component.get("v.selectedSubType");
             var JSONFromEndPoint = a.getReturnValue();
             try{
                var jsonBody = JSONFromEndPoint.body;
                jsonBody = JSON.parse(jsonBody);
                var typeSubTypeArr  = [];
                typeSubTypeArr      = jsonBody.IntegrationEntities.integrationEntity[0].integrationEntityDetails.metadataDefinition.contractMetadata.metadataDetails;
                var fieldDetails    = [];
                for(var i = 0; i < typeSubTypeArr.length; i++){
                    if(typeSubTypeArr[i].type == selType && typeSubTypeArr[i].subType == selSubType){
                        for(var j = 0; j < typeSubTypeArr[i].fieldMetadata.fieldDetails.length; j++){
                            if(typeSubTypeArr[i].fieldMetadata.fieldDetails[j].subFields != undefined){
                                for(var k = 0; k < typeSubTypeArr[i].fieldMetadata.fieldDetails[j].subFields.length; k++){
                                    typeSubTypeArr[i].fieldMetadata.fieldDetails[j].subFields[k].isDependent = true;
                                    typeSubTypeArr[i].fieldMetadata.fieldDetails[j].subFields[k].dependantFields = typeSubTypeArr[i].fieldMetadata.fieldDetails[j].fieldName;
                                    fieldDetails.push(typeSubTypeArr[i].fieldMetadata.fieldDetails[j].subFields[k]);  
                                }
                            }else{
                                if(typeSubTypeArr[i].fieldMetadata.fieldDetails[j].dataType != "File")
                                 fieldDetails.push(typeSubTypeArr[i].fieldMetadata.fieldDetails[j]);                      
                            }
                        }
        //                    fieldDetails    = typeSubTypeArr[i].fieldMetadata.fieldDetails; 
                        break;
                    }
                }
                component.set("v.allFields",fieldDetails);
                component.set("v.isFieldAvailable",true);
                this.checkSelectedFields(component, event, helper);
                component.set("v.Spinner", false);
             }catch(e){
                 debugger;
                document.getElementById("FieldMappingErrModal").style.display = "block" ; 
                component.getEvent("goToHomePage").fire();
             }
            
        });
        
        $A.enqueueAction(action);
    },


    goToHomePageOnErrMsg : function(component, event, helper){
        document.getElementById("FieldMappingErrModal").style.display = "none" ; 
        component.getEvent("goToHomePage").fire();
    },


	checkSelectedFields : function(component, event, helper) {
        var action = component.get("c.getExistingSelFieldRecords");
        action.setParams({
            "selType" : component.get("v.selectedType"),
            "selSubType" : component.get("v.selectedSubType")
        });
        
        action.setCallback(this, function(a) {
            var res 			= a.getReturnValue();
            var allFields 		= component.get("v.allFields");
            var selFieldsCount 	= 0;
            if(res.length > 0){
                for(var i = 0; i < allFields.length ; i++){
                    if(allFields[i].mandatory == 'YES'){
                        allFields[i].isSelected = true;
                        selFieldsCount = selFieldsCount + 1;
                    }else{
                        if(res.indexOf(allFields[i].fieldName) > -1){
                        allFields[i].isSelected = true;
                        selFieldsCount = selFieldsCount + 1;
                        }    
                    }
                    
                } 
                component.set("v.selectedCount", selFieldsCount);
                component.set("v.allFields",allFields);
            }else{
                for(var i = 0; i < allFields.length ; i++){
                    if(allFields[i].mandatory == 'YES'){
                        allFields[i].isSelected = true;
                        selFieldsCount = selFieldsCount + 1;
                    }else{
                        if(res.indexOf(allFields[i].fieldName) > -1){
                        allFields[i].isSelected = true;
                        selFieldsCount = selFieldsCount + 1;
                        }    
                    }
                }
                component.set("v.selectedCount", selFieldsCount);
                component.set("v.allFields",allFields);
            }
            component.set("v.prevSelectedFields",res);
            var compEvent = component.getEvent("selectedFieldCountEvt");
            compEvent.setParams({"selectedFieldCount" : component.get("v.selectedCount")});                
            compEvent.fire();
        });
        
        $A.enqueueAction(action);
    }
})