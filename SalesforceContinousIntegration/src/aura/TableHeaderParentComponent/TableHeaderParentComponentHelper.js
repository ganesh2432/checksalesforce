({
    //Savind function
   Save: function(component, event, helper) {
       component.set("v.Spinner", true);
       if(component.get("v.allowSaveOnlyOnce")==true){
           return;
       }
       component.set("v.allowSaveOnlyOnce",true);
     var SelectedRqustWizardList = component.get("v.SelectedRequestWizardList");
             
          var saveRequestWizards = true;    
          var emptyorder = true;
          var fieldName = '';
       var emptyOrderfield ='';
          component.set("v.QuestionEmptyFieldName",""); 
          var selectedRequestContractWizard = [];     
          var restOrderNumberIncrement = 0;         
          var duplicateOrderNoCheck = [];    
          var atleastOneQuestionSetup = false;
          for(var i=0;i<SelectedRqustWizardList.length;i++){
              
           //to check if atleast one field is mandatory for moving to next step
              if(SelectedRqustWizardList[i].IsRequired__c==false){
                  atleastOneQuestionSetup = true;
              }   
           
              if(SelectedRqustWizardList[i].Order_No__c > SelectedRqustWizardList.length){
                  component.set("v.allowSaveOnlyOnce",false);
                  component.set("v.emptyQuestionErrorMsg",'Order Number for '+SelectedRqustWizardList[i].Field_Name__c+' field is greater than the number of selected questions.'); 
                  document.getElementById("EmptyQuestionField").style.display = "block" ;component.set("v.Spinner", false);  return;
              }   
              
           if(SelectedRqustWizardList[i].Order_No__c!="" && SelectedRqustWizardList[i].Order_No__c!=undefined){  
              if(!duplicateOrderNoCheck.includes(SelectedRqustWizardList[i].Order_No__c)){
                duplicateOrderNoCheck.push(SelectedRqustWizardList[i].Order_No__c);
              }else{
                 saveRequestWizards = false;
                  component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.Duplicate_Order_Number_Message")+' '+SelectedRqustWizardList[i].Field_Name__c+' field.'); 
                  document.getElementById("EmptyQuestionField").style.display = "block" ;component.set("v.Spinner", false);  return;
              }
              }
              
              
              if(SelectedRqustWizardList[i].Question__c == '' && SelectedRqustWizardList[i].IsRequired__c==false){
                  saveRequestWizards = false;
                  fieldName = SelectedRqustWizardList[i].Field_Name__c;
                  break;
              }
              debugger;
              if((SelectedRqustWizardList[i].Order_No__c == '' || SelectedRqustWizardList[i].Order_No__c == undefined) && SelectedRqustWizardList[i].IsRequired__c==false){
                  emptyorder = false;
                  emptyOrderfield = SelectedRqustWizardList[i].Field_Name__c;
                  break;
              }
              
              if(SelectedRqustWizardList[i].Question__c == '' && SelectedRqustWizardList[i].IsRequired__c==true){
                  SelectedRqustWizardList[i].Question__c = $A.get("$Label.c.Question_prefix")+' '+SelectedRqustWizardList[i].Field_Name__c;   
              }
              if(SelectedRqustWizardList[i].Order_No__c == ""/* && SelectedRqustWizardList[i].IsRequired__c==false*/){
                 SelectedRqustWizardList[i].Order_No__c =  SelectedRqustWizardList.length - restOrderNumberIncrement;
                 restOrderNumberIncrement = restOrderNumberIncrement + 1; 
              }
              if(SelectedRqustWizardList[i].IsRequired__c==true){
                   SelectedRqustWizardList[i].Order_No__c = '';
              }
              selectedRequestContractWizard.push({ "sobjectType": "Request_Wizard_MetaData__c","Order_No__c":SelectedRqustWizardList[i].Order_No__c, "Field_Name__c": ""+SelectedRqustWizardList[i].Field_Name__c+"", "Question__c": ""+SelectedRqustWizardList[i].Question__c+"", "Mandatory__c": SelectedRqustWizardList[i].Mandatory__c, "IsRequired__c": false,"IContract_Field_Metadata__c":SelectedRqustWizardList[i].IContract_Field_Metadata__c,"Type__c":SelectedRqustWizardList[i].Type__c,"SubType__c":SelectedRqustWizardList[i].SubType__c,"Id":SelectedRqustWizardList[i].Id,"IsRequired__c":SelectedRqustWizardList[i].IsRequired__c,"Mandatory_in_Icontract__c":SelectedRqustWizardList[i].Mandatory_in_Icontract__c});

          }
       
       
       if(atleastOneQuestionSetup  == false){
           component.set("v.allowSaveOnlyOnce",false);
           component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.Min_1_field_setup_question_message")); 
           document.getElementById("EmptyQuestionField").style.display = "block" ;component.set("v.Spinner", false);  return;
       }else{
       if(emptyorder == true){
          if(saveRequestWizards == true){
              component.set("v.allowSaveOnlyOnce",true);
            var action = component.get("c.SaveRequestWizard");
            action.setParams({
                "reqWizardList":selectedRequestContractWizard
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {component.set("v.Spinner", false);
                    $A.get("e.c:MoveToStepFive").fire();
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
          }else{
              component.set("v.allowSaveOnlyOnce",false);
           component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.Please_fill_Question_empty_etxt")+' '+fieldName+' field.'); 
           document.getElementById("EmptyQuestionField").style.display = "block" ; component.set("v.Spinner", false); return; 
          }
       }else{
           component.set("v.allowSaveOnlyOnce",false);
           component.set("v.emptyQuestionErrorMsg",$A.get("$Label.c.OrderNo_empty_text_message")+' '+emptyOrderfield+' field.'); 
           document.getElementById("EmptyQuestionField").style.display = "block" ; component.set("v.Spinner", false); return;
       }}
   },
    //on skip button save. which will overide answered questionsand add deafult question and create
    SaveOnSkip : function(component, event, helper){
        component.set("v.Spinner", true);
        var SelectedRqustWizardList = component.get("v.SelectedRequestWizardList");
        
        var selectedRequestContractWizard = [];     
          for(var i=0;i<SelectedRqustWizardList.length;i++){
              
              SelectedRqustWizardList[i].Question__c = $A.get("$Label.c.Question_prefix_Text")+' '+SelectedRqustWizardList[i].Field_Name__c;   
              SelectedRqustWizardList[i].Order_No__c =  i+1;
              SelectedRqustWizardList[i].IsRequired__c = false;
              SelectedRqustWizardList[i].Mandatory__c = false;
              selectedRequestContractWizard.push(SelectedRqustWizardList[i]);
          }
        
         var action = component.get("c.SaveRequestWizard");
            action.setParams({
                "reqWizardList":selectedRequestContractWizard
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.Spinner", false);
                    $A.get("e.c:MoveToStepFive").fire();
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
    }
})