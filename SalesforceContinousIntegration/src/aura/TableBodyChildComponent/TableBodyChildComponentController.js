({
    //on load function
    doInit : function(component,event,helper){
       if(component.get("v.RequestWizardInstance").Mandatory_in_Icontract__c == true){
            component.set("v.disableRemoveLinkStrng","disabled");
            component.set("v.disableCheckBox", true);
        }
        component.getEvent("OrderIndexDuplicateCheckEvnt").setParams({ "orderNo": component.get("v.RequestWizardInstance").Order_No__c,"rowIndex":component.get("v.rowIndex")}).fire();
    },
    // after dom loaded
    doneRendering : function(component,event,helper){
        if(component.get("v.RequestWizardInstance").IsRequired__c == true){
            component.set("v.disable", true); 
            component.set("v.disableCheckBox", true);
            document.getElementById(component.get("v.rowIndex")+"disableRow").style.backgroundColor = 'rgb(237, 229, 229)';
            document.getElementById(component.get("v.rowIndex")+"AddBack").style.display = 'block';
            document.getElementById(component.get("v.rowIndex")+"Remove").style.display = 'none';
            
            }
    },
    //on click of remove link to disable the entire row
    remove : function(component,event,helper){debugger;
        component.set("v.disable", true); 
        component.set("v.disableCheckBox", true);
        component.get("v.RequestWizardInstance").IsRequired__c = true;
        
        document.getElementById(component.get("v.rowIndex")+"disableRow").style.backgroundColor = 'rgb(237, 229, 229)';
        document.getElementById(component.get("v.rowIndex")+"AddBack").style.display = 'block';
        document.getElementById(component.get("v.rowIndex")+"Remove").style.display = 'none';
        
        if(component.get("v.RequestWizardInstance").Question__c != ""){
           component.getEvent("DeleteRow").setParams({"ordernum" : component.get("v.RequestWizardInstance").Order_No__c}).fire();
            component.getEvent("RemovedQuestion").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
            
        }else{
            component.getEvent("DeleteRow").setParams({"ordernum" :component.get("v.RequestWizardInstance").Order_No__c}).fire();
        }                                     
        component.getEvent("addRowDeleteRowOrderNoEvt").setParams({"orderNum" : component.get("v.RequestWizardInstance").Order_No__c,"rowIndex":component.get("v.rowIndex"),"isRemove":true}).fire();
        
        
    },
    //on click of add back link to enable the entire row
    addBack : function(component,event,helper){
        component.set("v.disable", false);
        component.set("v.disableCheckBox", false);
        component.get("v.RequestWizardInstance").IsRequired__c = false;                                       
        document.getElementById(component.get("v.rowIndex")+"disableRow").style.backgroundColor = 'transparent'; 
        document.getElementById(component.get("v.rowIndex")+"AddBack").style.display = 'none';
        document.getElementById(component.get("v.rowIndex")+"Remove").style.display = 'block'; 
        
        if(component.get("v.RequestWizardInstance").Question__c != ""){
            component.getEvent("AddRow").fire(); 
            component.getEvent("FilledQuestion").setParams({"indexVar":component.get("v.rowIndex")}).fire();
        }else{
            component.getEvent("AddRow").fire(); 
        }                                         
        
    },
    //when question is filled onchange event to update the count and percent of question answered in parent component
    filledQuestionEvnt : function(component,event,helper){
        if(component.get("v.RequestWizardInstance").Question__c != ""){
            component.getEvent("FilledQuestion").setParams({"indexVar":component.get("v.rowIndex")}).fire();
        }else{
            component.getEvent("RemovedQuestion").setParams({"indexVar":component.get("v.rowIndex")}).fire();
        }
    },
    //order index duplicate check
    orderIndexduplicateCheck : function(component,event,helper){
        
        if(component.get("v.RequestWizardInstance").Order_No__c == ""){
            component.getEvent("OrderIndexRemoveEvt").setParams({"rowIndexs":component.get("v.rowIndex"),"orderNum":component.get("v.RequestWizardInstance").Order_No__c}).fire();
        }else{
            component.getEvent("OrderIndexRemoveEvt").setParams({"rowIndexs":component.get("v.rowIndex"),"orderNum":component.get("v.RequestWizardInstance").Order_No__c}).fire();
            
            component.getEvent("OrderIndexAddEvt").setParams({"orderNo":component.get("v.RequestWizardInstance").Order_No__c,"rowIndex":component.get("v.rowIndex")}).fire();
        }
    },
    //to remove duplicate order number
    removeDuplicateOrderNo : function(component,event,helper){
        component.get("v.RequestWizardInstance").Order_No__c = "";
    }
})