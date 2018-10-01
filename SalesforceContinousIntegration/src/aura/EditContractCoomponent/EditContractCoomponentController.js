({
    //used to get all the contract details for validation process
    doInit:function(component, event, helper){
        
        var action = component.get("c.getTypeandSubType");
        action.setParams({
            "contrctId":component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var response = response.getReturnValue();
            
            var icontractStatus = $A.get("$Label.c.Allowed_Icontract_Statuses");
            if(!icontractStatus.includes(response.IContract_Status__c)){
                component.set("v.icontrctStatus",response.IContract_Status__c);
                component.set("v.openProgressBar",true);
                component.set("v.notallowedStatusmsg",true);return;
            }
            
            if(response.Type__c == null || response.Type__c == undefined || response.Type__c =="" || response.Type__c == "null"){
                component.set("v.isRequestWizardContrct",false);
                return;
            }
            
            
            component.set("v.typeSelectedValue",response.Type__c);
            component.set("v.subTypeSelectedValue",response.SubType__c);
            component.set("v.opportunityId",response.Opportunity__c);
            component.set("v.IsstandardTemplate",response.IsStandardTemplate__c);
            component.set("v.templateName",response.Template_Name__c);
            component.set("v.templateId",response.Template_DocumentId__c);
            component.set("v.isRequestWizardContrct",response.Is_RequestWizard_Contract__c);
            component.set("v.scoperunningcrt",false);debugger;
            if(response.Contract_Number__c!=undefined && response.Contract_Number__c!='null' && response.Contract_Number__c!='')
            component.set("v.iscontractnumberPresent",true);
            
            if(component.get("v.isclassic")==true){
                component.set("v.openProgressBar",true);
            }
        });       
        $A.enqueueAction(action);
    },
    //redirect to Edit component on confirmation
    redirectToProgressBar : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();  
        debugger;
        var allowEditInEdit = false;
        if(component.get("v.iscontractnumberPresent") == false){
            allowEditInEdit = true;
            component.set("v.scoperunningcrt",true);
        }
        
        var urlEvent = $A.get("e.force:navigateToComponent");  
        urlEvent.setParams({
            componentDef: "c:LightningCreateContractProgressIndicator",
            componentAttributes:{
                contractRecId:component.get("v.recordId"),
                typeSelectedValue:component.get("v.typeSelectedValue"),
                subTypeSelectedValue:component.get("v.subTypeSelectedValue"),
                isEditing:true,
                scoperunningcreate :allowEditInEdit,
                isContractnumPresent:component.get("v.iscontractnumberPresent")
            }
        });
        urlEvent.fire();
    },
    closeQuickActin : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();  
    },
    redirectToContractDetailPage : function(component, event, helper){
        window.location.href = "/"+component.get("v.recordId"); 
    }
})