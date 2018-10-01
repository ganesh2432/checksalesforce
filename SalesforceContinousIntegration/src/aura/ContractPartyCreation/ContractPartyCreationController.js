({
	doInit : function(component, event, helper) {
		console.log('id'+component.get("v.recordId"));
	},
    searchAllContractParty : function(component, event, helper){
        component.find("contractcpAPI").searchAllContractpartyData();
    },
     contractPartySelectedData : function(component, event, helper){
       var selectedConpartyData		= event.getParam("contractPartySelectedData"); 
       component.set("v.contractPartySelectedetails",selectedConpartyData);
       console.log(JSON.stringify(component.get("v.contractPartySelectedetails")));
       component.set("v.contractPartyName",selectedConpartyData.legalName); 
       helper.ContractPartyUpdate(component,event, helper);
       //var dismissQuickAction = $A.get("e.force:closeQuickAction");
       //dismissQuickAction.fire();
    },
    backNextVisibilityCP:function(component, event, helper){
        var pageno = event.getParam("currntpageno");
        var isDataExistForNextPage = event.getParam("stillDataExist");
        component.set("v.currentpageCP",pageno);
        component.set("v.displayNextCP",isDataExistForNextPage);
        
    },
     BackActionforCP : function(component, event, helper){
        component.find("contractcpAPI").getBack();
    },
    NextActionforCP : function(component, event, helper){
        component.find("contractcpAPI").goNext();
    },
    CreateCP : function(component, event, helper){
        component.set("v.Spinner", true);
        helper.CreateCPHelper(component,event, helper);
    },
    closePopup : function(component,event,helper){
        var dismissQuickAction = $A.get("e.force:closeQuickAction");
        dismissQuickAction.fire();
    },
})