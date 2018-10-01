({
    getIContractFields: function(component,event,helper,mapConfigId){
        var action = component.get("c.getIContractFields");
        action.setParams({"mapConfigId":mapConfigId});
        action.setCallback(this,function(response){
                       
           //get the response state
            var state = response.getState();
            console.log(state);
            //check if result is successfull
            if(state == "SUCCESS"){
               component.set("v.Spinner", false);
               component.set("v.iContractFieldsList",response.getReturnValue());
                var iContractFields = component.get("v.iContractFieldsList");               
                var a = component.get('c.popValues');
        		$A.enqueueAction(a);
            }
            else if(state == "ERROR"){
                component.set("v.Spinner", false);
                component.set("v.SuccessErrormsg",$A.get("$Label.c.Value_Mapping_Error"));
                document.getElementById("SuccessErrorModal").style.display = "block" ;                 
            }                     
            
        });$A.enqueueAction(action);
    },    
    getPicklistValues:function(component, event, helper,mapConfigId,enumObjValues,piList){   	
        var action = component.get("c.getPicklistValues");
    	action.setParams({"MappingConfigId":mapConfigId,"JsonobjFieldWrap":JSON.stringify(enumObjValues),"AllowedValues":piList});
        action.setCallback(this, function(response){                                   
            
            //get the response state
            var state = response.getState();
            //check if result is successfull
            if(state == "SUCCESS"){
               var pickvalWrap =[];
               component.set("v.pickValueWrapper",pickvalWrap);
               component.set("v.pickValueWrapper",response.getReturnValue());
                var pickValueList = [];
                pickValueList = response.getReturnValue();                
                for(var i=0;i<pickValueList.length;i++){
                    if(pickValueList[i].fieldName2 == null || pickValueList[i].fieldName2 == ''){                    	
                        component.set("v.notMapped", true);    
                    }
                }
               component.set("v.Spinner", false);
            }
            else if(state == "ERROR"){
                component.set("v.Spinner", false);
                component.set("v.SuccessErrormsg",$A.get("$Label.c.Value_Mapping_Error"));
                document.getElementById("SuccessErrorModal").style.display = "block" ;                 
            }
        });$A.enqueueAction(action);
	},
    getSaveDetails : function(component,event,helper){        
        var action = component.get("c.savePickListValues");
        action.setParams({"JSONSaveDetails":JSON.stringify(component.get("v.pickValueWrapper")),"IContractList":component.get("v.iContractFieldsList")});
        action.setCallback(this,function(response){
            //get the response state
            var state = response.getState();
            //check if result is successfull
            if(state == "SUCCESS"){
                if(component.get("v.finalSavePopup") == true ){
                	helper.checkAllMappingValues(component,event,helper);
                    component.set("v.finalSavePopup",false);
                }            	
                
                
                
            }
            else if(state == "ERROR"){
                component.set("v.Spinner", false);
                component.set("v.SuccessErrormsg",$A.get("$Label.c.Value_Mapping_Error"));
                document.getElementById("SuccessErrorModal").style.display = "block" ;                 
            }
        });$A.enqueueAction(action);
    },
    popValues : function(component,event,helper){             
        //Save the previous value mapping values
        if(component.get("v.pickValueWrapper").length>0){           
            helper.inCompleteValueChecking(component,event,helper);
            if(component.get("v.allowSave") == true){              
                helper.getSaveDetails(component,event,helper);
                var pickvalWrap =[];
                component.set("v.pickValueWrapper",pickvalWrap);   
            }            
        }
        //Fetch dropdown values from DB.
        if(component.get("v.allowSave") == true){
            //Variabled declaration
            var ctr;
            var cval;
            component.set("v.notMapped", false);
            if(component.get("v.firstVal") == true && component.get("v.finalSaveWithOutExit") == false){
                component.set("v.Spinner", false);
                cval = 0;                
                component.set("v.firstVal",false);
                var Elements = component.find('main');                
                $A.util.addClass(Elements[0], "slds-popover slds-nubbin_right-bottom thSelect");             
            }
            else if(component.get("v.finalSaveWithOutExit") == true){
                console.log('111222');
                var enmList = [];
        		enmList = component.get("v.iContractFieldsList");
                var unmappedvalues = [];
                unmappedvalues = component.get("v.unMappedList");
                var unmappedValue = unmappedvalues[0];
                for(var i=0 ; i<enmList.length;i++){
                    if(unmappedValue == enmList[i].Display_Name__c){
                        cval = i;                        
                    }
                }
               var Elements = component.find('main');
               for (var i = 0; i < enmList.length; i++) {
                   var val = i;    
                    if(val != cval){
                        $A.util.removeClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    } else {
                        $A.util.addClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    }
            	}
                component.set("v.finalSaveWithOutExit", false);
                
            }
            else{                
               ctr = event.currentTarget;
               cval = ctr.dataset.value;                
               var Elements = component.find('main');
               for (var i = 0; i < Elements.length; i++) {
                   var val = Elements[i].getElement().getAttribute('data-value');    
                    if(val != cval){
                        $A.util.removeClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    } else {
                        $A.util.addClass(Elements[i], "slds-popover slds-nubbin_right-bottom thSelect");
                    }
            	}
            }                       
        var enmList = [];
        enmList = component.get("v.iContractFieldsList");        
        var enmValues = component.get("v.enumValues");
        enmValues = [];
        enmValues.push({'FieldName':enmList[cval].Field_Name__c,'Allowedvalues':enmList[cval].AllowedValues__c})        
        var allvar = enmValues[0].Allowedvalues;
        var flvar = enmValues[0].FieldName;        
        var piList = [];
        var splitvar = allvar.split(',');
        for(var i = 0; i < splitvar.length; i++) {
           // Trim the excess whitespace.
           splitvar[i] = splitvar[i].replace(/^\s*/, "").replace(/\s*$/, "");
           // Add additional code here, such as:
           piList.push(splitvar[i]);
        }       
        component.set("v.piValues",piList);
        
        //Salesforce Objects picklist values
        var enumObjValues = component.get("v.enumobjs");
        enumObjValues = [];        
        enumObjValues.push({'IContractFieldName':enmList[cval].Field_Name__c,'ObjectName1':enmList[cval].Mapping_Object__c,'FieldName1':enmList[cval].Mapping_Field__c,'ObjectName2':enmList[cval].Mapping_Object_2__c,'FieldName2':enmList[cval].Mapping_Field_2__c});     
        var mapConfigId = component.get("v.mapConfigIdNew");      
        helper.getPicklistValues(component, event, helper,mapConfigId,enumObjValues,piList);
        }
    },
    savePickVals: function(component,event,helper){
        helper.inCompleteValueChecking(component,event,helper);        
        
        if(component.get("v.allowSave") == true){
            helper.getSaveDetails(component,event,helper);
            //var pickvalWrap =[];
            //component.set("v.pickValueWrapper",pickvalWrap);  
        }                
	},
    
    checkAllMappingValues : function(component,event,helper){
        var mapConfigId = component.get("v.mapConfigId") 
        console.log(mapConfigId);
        var action = component.get("c.getAllPicklistValues");
        action.setParams({"MappingConfigId":mapConfigId,"IContractFieldData":component.get("v.iContractFieldsList")});
        action.setCallback(this,function(response){                      
           //get the response state
            var state = response.getState();
            console.log(state);
            //check if result is successfull
            if(state == "SUCCESS"){
               component.set("v.Spinner", false);
               component.set("v.unMappedList",response.getReturnValue());
			   var unMappedFieldList = response.getReturnValue();
                if(unMappedFieldList.length>0){
                    var upmappedFieldErrorMssg= '';
                    for(var i=0;i<unMappedFieldList.length;i++){
                        upmappedFieldErrorMssg = '<center><li style="text-align:center;list-style-type:none;">'+upmappedFieldErrorMssg +(i+1)+': ' +unMappedFieldList[i]+'</li></center><br/>';
                    }
                    
                    if(unMappedFieldList.length == 1){
                      upmappedFieldErrorMssg = '<center><b style="font-size: 136%;text-align: left">'+$A.get("$Label.c.Value_Mapping_not_completed_for_IContract_Value")+'</b></center><br/>' + upmappedFieldErrorMssg;  
                    }else{
                      upmappedFieldErrorMssg = '<center><b style="font-size: 136%;text-align: left">'+$A.get("$Label.c.Value_Mapping_not_completed_for_IContract_Values")+'</b></center><br/>' + upmappedFieldErrorMssg;  
                    }
                    
                    component.set("v.fieldMismatchErrMsg", upmappedFieldErrorMssg);
			        document.getElementById("FieldMismatchErrorMessageModal").style.display = "block" ;
                }else{
                    component.set("v.finalSavePopup",true);                    
                    component.set("v.Spinner", false);        
                    // by jayanth
                    var compEvent = $A.get("e.c:MovetoNextProgressBarEvt");
                    compEvent.setParams({"movetoStep" : "step4", "mappingConfigId" : component.get("{!v.mapConfigId}")})                
                    compEvent.fire(); 
                    if(component.get("v.finalSavePopup") == true){
                    	component.set("v.currStep",'step4');
                    }
                }                
            }
            else if(state == "ERROR"){
                component.set("v.Spinner", false);
                component.set("v.SuccessErrormsg",$A.get("$Label.c.Value_Mapping_Error"));
                document.getElementById("SuccessErrorModal").style.display = "block" ;                 
            }                     
            
        });$A.enqueueAction(action);
    },
    
    inCompleteValueChecking : function(component,event,helper){
         var pickvalWrap = component.get("v.pickValueWrapper");           
            component.set("v.allowSave",true);
            var arrValues1 = [];
            var arrValues2 = [];
            var duplicateFieldSelectCheck = [];
        	var duplicateFieldMatchErrMsg = '';
        	var duplicateCheckValues= false;
        	var k = 1;
            var errSeq = 1;
            var unmappedValue = false;
            for(var i = 0; i < pickvalWrap.length; i++){
                if(pickvalWrap[i].Value1 == 'Select' || pickvalWrap[i].Value2 == 'Select'){
                    component.set("v.Spinner", false);
                    component.set("v.allowSave",false);
                    unmappedValue = true;
                    component.set("v.SuccessErrormsg",$A.get("$Label.c.Value_Mapping_InComplete"));
                    document.getElementById("SuccessErrorModal").style.display = "block" ;                                       
                }
                else{
                    var val1 = pickvalWrap[i].Value1;
                	var val2 = pickvalWrap[i].Value2;
                    var objName1 = pickvalWrap[i].objName1;
                    var objName2 = pickvalWrap[i].objName2;
                    var iContractValue = pickvalWrap[i].IContractValue;
                    console.log('....111'+arrValues1.indexOf(val1));
                    if(arrValues1.indexOf(val1) != -1 && arrValues1.indexOf(val1)!=null){
                            duplicateFieldMatchErrMsg  += '<b>' + errSeq + ': </b>' +'Duplicate value match found in <b>' + objName1 + '</b> at <b>'+ iContractValue + '</b><br/>';
                            errSeq++;
                            duplicateCheckValues = true;                                                	                  
                    }
                    arrValues1.push(val1);
                    console.log(arrValues1);
                    if(val2!=null && val2!=''){
                    if(arrValues2.indexOf(val2) != -1 && arrValues2.indexOf(val2)!=null){
                    	    duplicateFieldMatchErrMsg  += '<b>' + errSeq + ': </b>' +'Duplicate value match found in <b>' + objName2 + '</b> at <b>'+ iContractValue + '</b><br/>';
                            errSeq++;
                            duplicateCheckValues = true;                                                  	                  
                    }
                    arrValues2.push(val2);
                    console.log(arrValues1);
                	}                                       
                }  
            }
            if(duplicateCheckValues && unmappedValue == false){
            	component.set("v.Spinner", false);
                component.set("v.allowSave",false);
                duplicateFieldMatchErrMsg = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Value_Mapping_Duplicates")+'</b></center><br/>' + duplicateFieldMatchErrMsg;               
                component.set("v.DuplicateValueErrMsg", duplicateFieldMatchErrMsg);
			    document.getElementById("DuplicateValueErrorMessageModal").style.display = "block" ; 
            }
            
    },
})