({
	//on load function which gets data from opportunity as default for mapped field 
	//during creation and from contract during edition
    doInit : function(component, event, helper) {
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        if(component.get("v.isEditing")!=true){
            helper.creationgetData(component, event, helper);
        }else{
            helper.EditinggetData(component, event, helper);
        }
    },
    
    //to create a contract record
    saveContractData : function(component, event, helper){
        component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :true}).fire();
        var reQdataWrpList = component.get("v.reqDatawrapperList");
        
        var createContract = [];
        var reqDataToCreateContract = component.get("v.reqDatawrapperList");
        
        //used for checking mandatory question filled or not
        var unansweredMandatoryQst= '';
        var unanswrd = 0; 
        for(var i=0;i<reqDataToCreateContract.length;i++){
            var j =0;
            if(i>=2){
                j= i+3;
            }else{
                j=i+1;
            }
            
            createContract.push({ dataType: reqDataToCreateContract[i].datatype,FieldApiName:reqDataToCreateContract[i].mappedFieldName1, FieldValue: ''+reqDataToCreateContract[i].answer});
            if((reqDataToCreateContract[i].answer == '' || reqDataToCreateContract[i].answer == null || reqDataToCreateContract[i].answer == undefined || reqDataToCreateContract[i].answer == ' ' || reqDataToCreateContract[i].answer == 'Select')&&(reqDataToCreateContract[i].mandatory == true)){
                unansweredMandatoryQst = '<center>'+unansweredMandatoryQst +(j)+': ' + reqDataToCreateContract[i].question+'</center><br/>';
                unanswrd =unanswrd + 1;
            }
            
        }
        
       //Contract Owner data upsert for contract     
       var selectedContrctData		= component.get("v.contractOwnerSelectedetails");
        if(selectedContrctData!=undefined){
         createContract.push({ dataType: "string",FieldApiName:"ContractOwnerUserId__c", FieldValue: ''+selectedContrctData.contractOwnerUserId});                                                   
         createContract.push({ dataType: "string",FieldApiName:"ContractOwnerFirstName__c", FieldValue: ''+selectedContrctData.firstName}); 
         createContract.push({ dataType: "string",FieldApiName:"ContractOwnerLastName__c", FieldValue: ''+selectedContrctData.lastName}); 
         createContract.push({ dataType: "string",FieldApiName:"ContractOwnerEmail__c", FieldValue: ''+selectedContrctData.email}); 
        } else{
          unansweredMandatoryQst = '<center>'+unansweredMandatoryQst +$A.get("$Label.c.error_message_for_not_filling_contract_owner_question")+'</center><br/>';  
        }
        
        //Contract part data upsert  for contract    
       var selectedContrctPartyData		= component.get("v.contractPartySelectedetails");
        if(selectedContrctPartyData!=undefined){
         createContract.push({ dataType: "string",FieldApiName:"ContractParty_LegalName__c", FieldValue: ''+selectedContrctPartyData.legalName});                                                   
         createContract.push({ dataType: "string",FieldApiName:"Contract_Party_CompanyName__c", FieldValue: ''+selectedContrctPartyData.companyType}); 
         createContract.push({ dataType: "string",FieldApiName:"Contract_Party_ExternalId__c", FieldValue: ''+selectedContrctPartyData.externalId}); 
         createContract.push({ dataType: "string",FieldApiName:"Contract_Party_contractingPartyGsid__c", FieldValue: ''+selectedContrctPartyData.contractingPartyGsid}); 
         createContract.push({ dataType: "string",FieldApiName:"Contract_Party_address__c", FieldValue: ''+selectedContrctPartyData.address});   
        } else{
          unansweredMandatoryQst = '<center>'+unansweredMandatoryQst +$A.get("$Label.c.error_message_for_not_filling_contract_party_question")+'</center><br/>';  
        }
        
        //Line item question value to upsert under contract
        if(component.get("v.allowLineItem")==true){
         createContract.push({ dataType: "boolean",FieldApiName:"Allow_Opportunity_LineItem_s__c", FieldValue: "true"});   
        }
       
        // for removing mandatory condition and creating contrct using below code later remove it
        unanswrd = 0;
        //
        
        //checks and throws error message if question are not filled or else upsert the contract data
        if(unanswrd >= 1){
            if(unanswrd == 1){
                unansweredMandatoryQst = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Message_to_fill_madatory_field_in_contract_creation")+'</b></center><br/>' + unansweredMandatoryQst;  
            }else{
                unansweredMandatoryQst = '<center><b style="font-size: 136%;">'+$A.get("$Label.c.Message_to_fill_madatory_fields_in_contract_creation")+'</b></center><br/>' + unansweredMandatoryQst;  
            }
            component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
            component.set("v.unanswrdqsterrormessage", unansweredMandatoryQst);
            document.getElementById("unansweredqstnErr").style.display = "block" ;
            return;
        }else{
            
            var stringfiedCreateContract = JSON.stringify(createContract);
            
            var action = component.get("c.createContractData");
            action.setParams({
                "contrctId":component.get("v.contractId"),
                "oppId":component.get("v.opportunityId"),
                "stageStr":stringfiedCreateContract,
                "selectedType":component.get("v.typeSelectedValue"),
                "selectedSubType":component.get("v.subTypeSelectedValue")
            });
            action.setCallback(this,function(response){
                var response = response.getReturnValue();
                if(response.includes('Exception') || response.includes($A.get("$Label.c.Acc_not_attched_to_OPP_error_message"))){
                   component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
                   alert(response);return;
                }
                
                component.set("v.contractId",response);
                component.getEvent("CreateContractSpinnerEvent").setParams({"spin" :false}).fire();
                component.getEvent("ContractPartyNameForHeader").setParams({"CPName" :component.get("v.contractPartyName")}).fire();//passingContractPartyName
                component.getEvent("ContrctMoveToSecndPageEvt").setParams({"moveToStepNo" : "step2","contractRecordId":component.get("v.contractId")}).fire();//moving to next step by firing an event to parent
                

            });       
            $A.enqueueAction(action);
            
        }

    },
    
    // No of Questions answered calculator
    onchangeQstCal : function(component, event, helper){
        var reQdataWrpList = component.get("v.reqDatawrapperList");

        var defaultAnsweredQstns = 0;
        if(component.get("v.countAnsweredonlyonce")==true && component.get("v.countAnsweredonlyonceCP")==true && component.get("v.isEditing")==false){
            defaultAnsweredQstns = 2;
        }else if((component.get("v.countAnsweredonlyonce")==true || component.get("v.countAnsweredonlyonceCP")==true) && component.get("v.isEditing")==false){
            defaultAnsweredQstns = 1;
        }                                               
        
        for(var i=0;i<reQdataWrpList.length;i++){
            if(reQdataWrpList[i].answer!=null && reQdataWrpList[i].answer!=undefined && reQdataWrpList[i].answer!='' && reQdataWrpList[i].answer!="Select" && reQdataWrpList[i].answer!=" " ){
                defaultAnsweredQstns = defaultAnsweredQstns + 1;
            }
        }
        
        component.set("v.answeredQuestionsLength",defaultAnsweredQstns); 
        component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
        
    },
    closeQuickAction : function(component, event, helper){
        document.getElementById("unansweredqstnErr").style.display = "none" ;  
    },
    //display contract owner popup for owner selection which gets attached to contract
    contractOwnerSearch : function(component, event, helper){
        document.getElementById("contractOwnerPopUp").style.display = "block" ; 
    },
    //display contract party popup for party selection which gets attached to contract
    contractPartyOwnerSearch : function(component, event, helper){
        document.getElementById("contractPartSearchPopUp").style.display = "block" ; 
    },
    //close contract party popup
    closePopUpForContrctParty : function(component, event, helper){
        document.getElementById("contractPartSearchPopUp").style.display = "none" ; 
    },
    //close contract owner popup
    closePopUpForContrctOwner : function(component, event, helper){
         document.getElementById("contractOwnerPopUp").style.display = "none" ;
    },
    //Pagination on back for CO
    BackAction : function(component, event, helper){
        component.find("contractOwnerAPI").getBack();
    },
    //Pagination on next for CO
    NextAction : function(component, event, helper){
        component.find("contractOwnerAPI").goNext();
    },
    //Pagination for CO
    backNextVisibility: function(component, event, helper){
        
        var pageno = event.getParam("currntpageno");
        var isDataExistForNextPage = event.getParam("stillDataExist");
        component.set("v.currentpage",pageno);
        component.set("v.displayNext",isDataExistForNextPage);
    },
    //Pagination for CP
    backNextVisibilityCP:function(component, event, helper){
        var pageno = event.getParam("currntpageno");
        var isDataExistForNextPage = event.getParam("stillDataExist");
        component.set("v.currentpageCP",pageno);
        component.set("v.displayNextCP",isDataExistForNextPage);
        
    },
    //to get all contract owner excluding the criteria
    searchAllContractOwner : function(component, event, helper){
        component.find("contractOwnerAPI").searchAllContractOwner();
    },
    //to update the contract owner selected data in parent component + answered question calculator
    contractOwnerselectedDetails :function(component, event, helper){
         var selectedConData		= event.getParam("contractOwnerSelectedData");
                 
        component.set("v.contractOwnerName",selectedConData.firstName+' '+selectedConData.lastName);
        component.set("v.contractOwnerSelectedetails",selectedConData);
        //var reqdataListToInsert = component.get("v.reqDatawrapperList");
        if(component.get("v.countAnsweredonlyonce") == false){
         component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
         component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
        
        }
        component.set("v.countAnsweredonlyonce",true);
        document.getElementById("contractOwnerPopUp").style.display = "none" ;
    },
    
    //Pagination on back for CP
    BackActionforCP : function(component, event, helper){
        component.find("contractcpAPI").getBack();
    },
    //Pagination on next for CP
    NextActionforCP : function(component, event, helper){
        component.find("contractcpAPI").goNext();
    },
    //to get all contract party excluding the criteria
    searchAllContractParty : function(component, event, helper){
        component.find("contractcpAPI").searchAllContractpartyData();
    },
    //to update the contract party selected data in parent component + answered question calculator
    contractPartySelectedData : function(component, event, helper){
       var selectedConpartyData		= event.getParam("contractPartySelectedData"); 
       component.set("v.contractPartySelectedetails",selectedConpartyData); 
       component.set("v.contractPartyName",selectedConpartyData.legalName); 
       if(component.get("v.countAnsweredonlyonceCP") == false){
         component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
         component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
        
        }
        component.set("v.countAnsweredonlyonceCP",true); 
         document.getElementById("contractPartSearchPopUp").style.display = "none" ; 
        
    },
    selectLineItem : function(component, event, helper){
        if(component.get("v.allowLineItem")==true){
            component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")+1);
         component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
        }else{
            component.set("v.answeredQuestionsLength",component.get("v.answeredQuestionsLength")-1);
         component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100);
        }
    }
})