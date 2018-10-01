({
	
    //onload function call to get set of CP from zycus endpoint
    doInit: function(component, event, helper){
        helper.callEndpointTogetCPData(component, event, helper,true);
    },
    
    //pagination of next button and to get data from zyucs 
    onNextPageClick : function(component, event, helper){

        component.set("v.spinnerinQuickActionCP",true);
        component.set("v.currentCPPage",component.get("v.currentCPPage")+1);
        helper.onNextPageClick(component, event, helper);
    },
    //pagination of back button and to get data from zyucs 
    onBackPageClick : function(component, event, helper){
        component.set("v.spinnerinQuickActionCP",true);
        component.set("v.currentCPPage",component.get("v.currentCPPage")-1);
        helper.onBackPageClick(component, event, helper);
    },
    //Validation for filter search
    searchContractPartyAPIByfilter : function(component, event, helper){
        component.set("v.currentCPPage",1);
        if(component.get("v.searchcpVal")!="" && component.get("v.searchcpVal").length>=3 && component.get("v.searchcpVal")!=undefined){
           component.set("v.spinnerinQuickActionCP",true);
            helper.callEndpointTogetCPData(component, event, helper,false);
           component.set("v.defaultcPdata",false); 
        }else{
           alert($A.get("$Label.c.Min_3_char_enter_for_CP_CO_search_error_msg")); 
        }
        
        
    },
    //To get all contract party from zycus
    searchAllCP:function(component, event, helper){
        component.set("v.spinnerinQuickActionCP",true);
        component.set("v.currentCPPage",1);
        component.set("v.searchcpVal","");
        helper.callEndpointTogetCPData(component, event, helper,true);
        component.set("v.defaultcPdata",true);
    },
    //fires when cp is selected
    selectedContractparty : function(component, event, helper){
        var selectedConptData		= event.getSource().get("v.value");
        component.getEvent("PassContractPartyDetailsEvnt").setParams({"contractPartySelectedData" : selectedConptData}).fire();
    },
    //asc sort based on location
    sortLocationASC : function(component, event, helper){
      var CPdataFrmIcon =  component.get("v.contractPartyDataList");  
      CPdataFrmIcon.sort(function(a,b) {return (a.address > b.address) ? 1 : ((b.address > a.address) ? -1 : 0);} );
      component.set("v.contractPartyDataList",CPdataFrmIcon);
    },
    //dsc sort based on location
    sortLocationDESC : function(component, event, helper){
        var CPdataFrmIcon =  component.get("v.contractPartyDataList");  
      CPdataFrmIcon.sort(function(a,b) {return (b.address > a.address) ? 1 : ((a.address > b.address) ? -1 : 0);} );
      component.set("v.contractPartyDataList",CPdataFrmIcon);
    },
    //asc sort based on Name
    sortCPNameASC : function(component, event, helper){
      var CPdataFrmIcon =  component.get("v.contractPartyDataList");  
      CPdataFrmIcon.sort(function(a,b) {return (a.legalName > b.legalName) ? 1 : ((b.legalName > a.legalName) ? -1 : 0);} );
      component.set("v.contractPartyDataList",CPdataFrmIcon);
    },
    //dsc sort based on Name
    sortCPNameDESC : function(component, event, helper){
        var CPdataFrmIcon =  component.get("v.contractPartyDataList");  
      CPdataFrmIcon.sort(function(a,b) {return (b.legalName > a.legalName) ? 1 : ((a.legalName > b.legalName) ? -1 : 0);} );
      component.set("v.contractPartyDataList",CPdataFrmIcon);
    },
    closePoppupcp : function(component, event, helper){
        document.getElementById("contractpartyError").style.display = "none" ;
    }
})