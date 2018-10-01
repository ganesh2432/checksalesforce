({
    // to get data to pre fill values from opportunity for contract creation
	creationgetData : function(component, event, helper) {
		                       
		var action = component.get("c.getContractDetails");
        action.setParams({
                "oppId":component.get("v.opportunityId"),
                "selectedType":component.get("v.typeSelectedValue"),
                "selectedSubType":component.get("v.subTypeSelectedValue")
            });
        action.setCallback(this,function(response){
            if(response.getReturnValue()=="Exception" || JSON.parse(response.getReturnValue())==null || JSON.parse(response.getReturnValue()).length==0){
                //component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
                alert($A.get("$Label.c.Opps_something_went_wrong_msg"));
                return;
            }
                var response = JSON.parse(response.getReturnValue());
                component.set("v.reqDatawrapperList",response);
            var reQdataWrpList = component.get("v.reqDatawrapperList");
           component.set("v.questionsLength",reQdataWrpList.length+3); 
            var reformattedPicklistData = [];

            var defaultAnsweredQstns = 0;
            for(var i=0;i<reQdataWrpList.length;i++){
                
                if(reQdataWrpList[i].datatype=="boolean"){
                    if(reQdataWrpList[i].answer == "true"){
                         reQdataWrpList[i].answer = true;
                    }else{
                        reQdataWrpList[i].answer = false;
                    } 
                }
                
                
               // creating the required format for multipicklist lightning element tag 
               if(reQdataWrpList[i].picklistValuestodisplay!=null && reQdataWrpList[i].picklistValuestodisplay.length>= 0 && (reQdataWrpList[i].datatype=='multipicklist')){
                   
                   for(var j=0;j<reQdataWrpList[i].picklistValuestodisplay.length;j++){
                       reQdataWrpList[i].picklistValuestodisplay[j] = {'label': reQdataWrpList[i].picklistValuestodisplay[j], 'value': reQdataWrpList[i].picklistValuestodisplay[j]};
                   } 
                   
               }
                
               // creating the required format for datetime+ date lightning element tag if val not present
                if(reQdataWrpList[i].datatype=='datetime'){
                    if(reQdataWrpList[i].answer == '' || reQdataWrpList[i].answer == ' ' || reQdataWrpList[i].answer == undefined){
                        reQdataWrpList[i].answer = null;
                    }
                }
                if(reQdataWrpList[i].datatype=='date'){
                    
                    if(reQdataWrpList[i].answer == '' || reQdataWrpList[i].answer == ' ' || reQdataWrpList[i].answer == undefined){
                        reQdataWrpList[i].answer = null;
                    }else{
                     var dateanswerSet = new Date(reQdataWrpList[i].answer);
                    var dateformat = new Date(); 
                    dateformat = dateanswerSet.getFullYear() + "-" + (dateanswerSet.getMonth() + 1) + "-" + dateanswerSet.getDate();                                        
                    reQdataWrpList[i].answer = dateformat;   
                    }
                } 
                if(reQdataWrpList[i].answer!=null && reQdataWrpList[i].answer!=undefined && reQdataWrpList[i].answer!='' && reQdataWrpList[i].answer!="" && reQdataWrpList[i].answer!=" " && reQdataWrpList[i].answer!="null"){
                    defaultAnsweredQstns = defaultAnsweredQstns + 1;
                }
            }
           
            component.set("v.reqDatawrapperList",reQdataWrpList);
            component.set("v.answeredQuestionsLength",defaultAnsweredQstns); 
            component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
           component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
        });       
            $A.enqueueAction(action);
	},
    
    // to get data to pre fill values from contract for contract edition
    EditinggetData : function(component, event, helper) {

		var action = component.get("c.getEditContractDetails");
        action.setParams({
                "contrctid":component.get("v.contractId"),
                "selectedType":component.get("v.typeSelectedValue"),
                "selectedSubType":component.get("v.subTypeSelectedValue")
            });
        
        action.setCallback(this,function(response){
            if(response.getReturnValue()=="Exception" || JSON.parse(response.getReturnValue())==null || JSON.parse(response.getReturnValue()).length==0){
                //component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
                alert($A.get("$Label.c.Opps_something_went_wrong_msg"));
                return;
            }
                var response = JSON.parse(response.getReturnValue());
                component.set("v.reqDatawrapperList",response);
            var reQdataWrpList = component.get("v.reqDatawrapperList");
           component.set("v.questionsLength",reQdataWrpList.length+3); 
            var reformattedPicklistData = [];
            
            var defaultAnsweredQstns = 0;
            for(var i=0;i<reQdataWrpList.length;i++){
                
                if(reQdataWrpList[i].datatype=="boolean"){
                    if(reQdataWrpList[i].answer == "true"){
                         reQdataWrpList[i].answer = true;
                    }else{
                        reQdataWrpList[i].answer = false;
                    } 
                }
                
                
               // creating the required format for multipicklist lightning element tag   
               if(reQdataWrpList[i].picklistValuestodisplay!=null && reQdataWrpList[i].picklistValuestodisplay.length>= 0 && (reQdataWrpList[i].datatype=='multipicklist')){
                   
                   for(var j=0;j<reQdataWrpList[i].picklistValuestodisplay.length;j++){
                       reQdataWrpList[i].picklistValuestodisplay[j] = {'label': reQdataWrpList[i].picklistValuestodisplay[j], 'value': reQdataWrpList[i].picklistValuestodisplay[j]};
                   } 
                   
               }
               // creating the required format for datetime+ date lightning element tag if val not present 
                if(reQdataWrpList[i].datatype=='datetime'){
                    if(reQdataWrpList[i].answer == '' || reQdataWrpList[i].answer == ' ' || reQdataWrpList[i].answer == undefined){
                        reQdataWrpList[i].answer = null;
                    }
                }
                if(reQdataWrpList[i].datatype=='date'){
                    
                    if(reQdataWrpList[i].answer == '' || reQdataWrpList[i].answer == ' ' || reQdataWrpList[i].answer == undefined){
                        reQdataWrpList[i].answer = null;
                    }else{
                       var dateanswerSet = new Date(reQdataWrpList[i].answer);
                    var dateformat = new Date(); 
                    dateformat = dateanswerSet.getFullYear() + "-" + (dateanswerSet.getMonth() + 1) + "-" + dateanswerSet.getDate();                                        
                    reQdataWrpList[i].answer = dateformat; 
                    }
                    
                }
                if(reQdataWrpList[i].answer!=null && reQdataWrpList[i].answer!=undefined && reQdataWrpList[i].answer!='' && reQdataWrpList[i].answer!="" && reQdataWrpList[i].answer!=" " && reQdataWrpList[i].answer!="null"){
                    defaultAnsweredQstns = defaultAnsweredQstns + 1;
                }
                
               
                
            }
           
            component.set("v.answeredQuestionsLength",defaultAnsweredQstns); 
            this.getContractOwnerDetails(component, event, helper);
            component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
            component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
            
        });       
            $A.enqueueAction(action);
	},
    // to get existing ocntract owner and contract party details from contract
    getContractOwnerDetails : function(component, event, helper){
        var getcontrctDataForEdit = component.get("c.getcontractOwnerdata");
        getcontrctDataForEdit.setParams({
                "contrctid":component.get("v.contractId")
            });
        
        getcontrctDataForEdit.setCallback(this,function(response){
            if(response.getReturnValue()!=null && response.getReturnValue()!=undefined){
             var contrctExistingdata = response.getReturnValue();
             if(contrctExistingdata.ContractOwnerFirstName__c!='' && contrctExistingdata.ContractOwnerFirstName__c!=null && contrctExistingdata.ContractOwnerFirstName__c!=undefined){
             var contractOwnerDetails = {firstName:contrctExistingdata.ContractOwnerFirstName__c, lastName:contrctExistingdata.ContractOwnerLastName__c, email:contrctExistingdata.ContractOwnerEmail__c, contractOwnerUserId:contrctExistingdata.ContractOwnerUserId__c};
             component.set("v.contractOwnerSelectedetails",contractOwnerDetails);
             component.set("v.contractOwnerName",contractOwnerDetails.firstName+' '+contractOwnerDetails.lastName);
                 component.set("v.countAnsweredonlyonce",true);
             component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
             component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
             }   
                
             if(contrctExistingdata.ContractParty_LegalName__c!='' && contrctExistingdata.ContractParty_LegalName__c!=null && contrctExistingdata.ContractParty_LegalName__c!=null){
             var contratPartyDetails = {legalName:contrctExistingdata.ContractParty_LegalName__c	,
                                        companyType:contrctExistingdata.Contract_Party_CompanyName__c,
                                       externalId:contrctExistingdata.Contract_Party_ExternalId__c,
                                        contractingPartyGsid:contrctExistingdata.Contract_Party_contractingPartyGsid__c,
                                        address:contrctExistingdata.Contract_Party_CompanyName__c
                                        };
             component.set("v.contractPartySelectedetails",contratPartyDetails);
             component.set("v.contractPartyName",contratPartyDetails.legalName);
             component.set("v.countAnsweredonlyonceCP",true);
             component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
             component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);    
                 
             }
               
                if(contrctExistingdata.Allow_Opportunity_LineItem_s__c == true){
                    component.set("v.allowLineItem",true);
                   component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
             component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);  
                }   
                
            }
        });       
            $A.enqueueAction(getcontrctDataForEdit);
    }
})