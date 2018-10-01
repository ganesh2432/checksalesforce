({
    //on load function call to get existing data if present
	doInit: function(component, event, helper) {
        component.set("v.Spinner", true);
        var RowItemList = component.get("c.getRequestWizardsMetadata");
        RowItemList.setParams({
                "selectedType":component.get("v.selectedType"),
                "selectedSubType":component.get("v.selectedSubType")
            });
        
        
        var rows = [];
        var fieldsList = [];
        RowItemList.setCallback(this,function(response){
                var rowList = response.getReturnValue();
                if(rowList == null){
                    document.getElementById("Exceptions").style.display = "block" ;
                    component.set("v.Spinner", false);
                    return;
                }
            
                var answeredQuestionLength = 0;
                var answeredQuestionCount = [];
                for(var i=0;i<rowList.length;i++){
                    fieldsList.push(rowList[i].Field_Name__c);
                    if(rowList[i].IsRequired__c == false){
                        answeredQuestionLength = answeredQuestionLength + 1;
                        answeredQuestionCount.push(i);
                        
                    }else{
                        //rowList[i].Order_No__c = '';
                    }
                    if (rowList[i].Question__c.indexOf("?") > -1 ){
                       rows.push({ "sobjectType": "Request_Wizard_MetaData__c","Order_No__c":rowList[i].Order_No__c, "Field_Name__c": ""+rowList[i].Field_Name__c+"", "Question__c": ""+rowList[i].Question__c, "Mandatory__c": rowList[i].Mandatory__c, "IsRequired__c": false,"IContract_Field_Metadata__c":rowList[i].IContract_Field_Metadata__c,"Type__c":rowList[i].Type__c,"SubType__c":rowList[i].SubType__c,"Id":rowList[i].Id,"IsRequired__c":rowList[i].IsRequired__c,"Mandatory_in_Icontract__c":rowList[i].Mandatory_in_Icontract__c});
                    }else{
                       rows.push({ "sobjectType": "Request_Wizard_MetaData__c","Order_No__c":rowList[i].Order_No__c, "Field_Name__c": ""+rowList[i].Field_Name__c+"", "Question__c": ""+rowList[i].Question__c+"?", "Mandatory__c": rowList[i].Mandatory__c, "IsRequired__c": false,"IContract_Field_Metadata__c":rowList[i].IContract_Field_Metadata__c,"Type__c":rowList[i].Type__c,"SubType__c":rowList[i].SubType__c,"Id":rowList[i].Id,"IsRequired__c":rowList[i].IsRequired__c,"Mandatory_in_Icontract__c":rowList[i].Mandatory_in_Icontract__c});
                    }
                    
                    //rows.push({ "sobjectType": "Request_Wizard_MetaData__c","Order_No__c":rowList[i].Order_No__c, "Field_Name__c": ""+rowList[i].Field_Name__c+"", "Question__c": ""+rowList[i].Question__c+"?", "Mandatory__c": rowList[i].Mandatory__c, "IsRequired__c": false,"IContract_Field_Metadata__c":rowList[i].IContract_Field_Metadata__c,"Type__c":rowList[i].Type__c,"SubType__c":rowList[i].SubType__c,"Id":rowList[i].Id,"IsRequired__c":rowList[i].IsRequired__c,"Mandatory_in_Icontract__c":rowList[i].Mandatory_in_Icontract__c});
                }
                component.set("v.SelectedRequestWizardList", rows);
                component.set("v.SelectedFieldsList", fieldsList);
                component.set("v.questionsLength",answeredQuestionLength);
                component.set("v.answeredQuestions",answeredQuestionCount);
                component.set("v.answeredQuestionsLength",answeredQuestionLength);
                component.set("v.questionCompletedPercent",(component.get("v.answeredQuestionsLength") / component.get("v.questionsLength"))*100); 
                component.set("v.Spinner", false);
            });       
            $A.enqueueAction(RowItemList);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        helper.Save(component, event, helper);
     },
    skipPopUp : function(component, event, helper){
        document.getElementById("newClientSectionId").style.display = "block" ;
    },
    disableSkipPopUp : function(component, event, helper){
       document.getElementById("newClientSectionId").style.display = "none" ;
    },
    //moving to final step
    goTodocSetup : function(component,event,helper){
        
        document.getElementById("newClientSectionId").style.display = "none" ;
        helper.SaveOnSkip(component, event, helper);                                            
        //$A.get("e.c:MoveToStepFive").fire();

    },
    //question length calculator when question filled
    FilledQuestionsLengthCalculator : function(component,event,helper){
       var index = event.getParam("indexVar");
       var answeredLength = component.get("v.answeredQuestions");
        if(!answeredLength.includes(index)){
            answeredLength.push(index);
        }
      component.set("v.answeredQuestionsLength",answeredLength.length);
                                                                       
      component.set("v.questionCompletedPercent",(answeredLength.length / component.get("v.questionsLength"))*100);
                                                                 
    },
    //question length calculator when question removed
    RemovedQuestionsLengthCalculator : function(component,event,helper){
       var index = event.getParam("indexVar");
       var answeredLength = component.get("v.answeredQuestions");
       
        //cant use includes here to filter out the flow, coz it check for index but not values inside index
       for(var i=0;i<answeredLength.length;i++){
                if(answeredLength[i] == index){
                    answeredLength.splice(i, 1);
                    break;
                }
            }
      component.set("v.answeredQuestions",answeredLength);
      component.set("v.answeredQuestionsLength",answeredLength.length);
      
      component.set("v.questionCompletedPercent",(answeredLength.length / component.get("v.questionsLength"))*100);
        
    },
     
    // function for delete the row / to disable the row
    removeDeletedRow: function(component, event, helper) {
        //get the selected row Index for delete, from Lightning Event Attribute  
        component.set("v.questionsLength",component.get("v.questionsLength")-1); 
        var answeredLength = component.get("v.answeredQuestions"); 
        component.set("v.questionCompletedPercent",(answeredLength.length / component.get("v.questionsLength"))*100);  
        
    },
    
    
    // function for create new object Row in req wiz List  / enabling the row as of now not creating new
    addRow: function(component, event, helper) {
       component.set("v.questionsLength",component.get("v.questionsLength")+1); 
        var answeredLength = component.get("v.answeredQuestions"); 
        component.set("v.questionCompletedPercent",(answeredLength.length / component.get("v.questionsLength"))*100);                                                  
    },
    CloseEmptyQuestionField : function(component, event, helper) {
       document.getElementById("EmptyQuestionField").style.display = "none" ; 
    },//duplicate order check
    OrderIndexDuplicateCheckEvnt : function(component,event,helper){
      var orderNum = event.getParam("orderNo"); 
      var rowIndex = event.getParam("rowIndex"); 
      var orderindWrp = component.get("v.OrderIndexWrapper");  
      if(orderindWrp != null){
      orderindWrp.push({"orderNo":orderNum,"rowIndex":rowIndex});
      component.set("v.OrderIndexWrapper",orderindWrp);
      }else{
      var orderindWrpWhenNull = [];
      orderindWrpWhenNull.push({"orderNo": orderNum,"rowIndex":rowIndex});
      component.set("v.OrderIndexWrapper",orderindWrpWhenNull);
      }
    },
    OrderIndexRemoveEvt : function(component,event,helper){
        var rowIndex = event.getParam("rowIndexs");
        var orderno = event.getParam("orderNum"); 
        var orderWrapperArray = component.get("v.OrderIndexWrapper");
        for(var i=0;i<orderWrapperArray.length;i++){
            if(orderWrapperArray[i].rowIndex == rowIndex){
                orderWrapperArray.splice(i,1);
            }
        }
        component.set("v.OrderIndexWrapper",orderWrapperArray);                                                   
    },
    OrderIndexAddEvt : function(component,event,helper){
        var orderNum = event.getParam("orderNo");
        var rowIndex = event.getParam("rowIndex");
        var orderWrapperArray = component.get("v.OrderIndexWrapper");   
        var onlyOnce = true; 
        var orderwrp = []; 
        if(orderNum<=0){
         component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.OrderNo_greater_than_zero")); 
         document.getElementById("EmptyQuestionField").style.display = "block" ; 
         component.find("tableChildComponent")[rowIndex].removeDuplicateOrder();return;                                                      
        }                                                 
        if(orderNum > component.get("v.questionsLength")){
              component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.OrderNumber_Label")+' '+orderNum+' '+$A.get("$Label.c.OrderNo_greater_than_the_selected_questions")); 
              document.getElementById("EmptyQuestionField").style.display = "block" ; 
              component.find("tableChildComponent")[rowIndex].removeDuplicateOrder();return;
            }                                                
        for(var i=0;i<orderWrapperArray.length;i++){
            
            if(orderWrapperArray[i].orderNo == orderNum){
                component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.OrderNumber_Label")+' '+orderNum+' '+$A.get("$Label.c.OrderNo_is_already_present")); 
                document.getElementById("EmptyQuestionField").style.display = "block" ; 
                component.find("tableChildComponent")[rowIndex].removeDuplicateOrder();
                onlyOnce = true;
                return;
            }else{
                onlyOnce = false;
            }orderwrp.push({"orderNo": orderWrapperArray[i].orderNo,"rowIndex":orderWrapperArray[i].rowIndex})  
        }
        //after inserting value again                                                
        if(onlyOnce == false){
           orderwrp.push({"orderNo":parseInt(orderNum),"rowIndex":rowIndex}); 
           component.set("v.OrderIndexWrapper",orderwrp); 
        }
    },
    addRowDeleteRowOrderNoEvt: function(component,event,helper){
       var DecrementOrderNoValue = component.get("v.SelectedRequestWizardList");
       var runjustOnce = false;
       var newOrderWrp = [];        
                                                                
       var rowIndex = event.getParam("rowIndex");
        var orderno = event.getParam("orderNum"); 
        var orderWrapperArray = component.get("v.OrderIndexWrapper");
        var newdecrementedWrpPush = [];    
                                                      
        for(var i=0;i<DecrementOrderNoValue.length;i++){
            if(DecrementOrderNoValue[i].Order_No__c == event.getParam("orderNum") && runjustOnce == false){
                DecrementOrderNoValue[i].Order_No__c = "";
                runjustOnce == true;
            }

            if(DecrementOrderNoValue[i].Order_No__c == ""){
                  DecrementOrderNoValue[i].Order_No__c = "";
                  newdecrementedWrpPush.push({"orderNo":"","rowIndex":i});
            }else{
             if(DecrementOrderNoValue[i].Order_No__c < orderno && orderno != ""){
                  DecrementOrderNoValue[i].Order_No__c = DecrementOrderNoValue[i].Order_No__c; 
                  newdecrementedWrpPush.push({"orderNo":DecrementOrderNoValue[i].Order_No__c,"rowIndex":i});
            }else if(DecrementOrderNoValue[i].Order_No__c > orderno && orderno != ""){
                  DecrementOrderNoValue[i].Order_No__c = DecrementOrderNoValue[i].Order_No__c-1;
                  newdecrementedWrpPush.push({"orderNo":DecrementOrderNoValue[i].Order_No__c,"rowIndex":i});
            }
            }
        }
        component.set("v.OrderIndexWrapper",newdecrementedWrpPush);
        component.set("v.SelectedRequestWizardList",DecrementOrderNoValue); 
    }
})