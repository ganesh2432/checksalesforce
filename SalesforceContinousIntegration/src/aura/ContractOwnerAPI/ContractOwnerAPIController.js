({
    // to display user defined text for api text selection
	pickValSelected : function(component, event, helper) {
		component.set("v.searchVal","");
        if(component.get("v.filterSelctedType")=="first_name"){
          component.set("v.searchingName","First Name");  
        }else if(component.get("v.filterSelctedType")=="last_name"){
          component.set("v.searchingName","Last Name");  
        }else if(component.get("v.filterSelctedType")=="email"){
          component.set("v.searchingName","Email");  
        }else if(component.get("v.filterSelctedType")=="select"){
          component.set("v.searchingName","");   
        }
        
	},
    
    //onload function which is called to get contract owner data by hitting zycus endpoint
    doInit: function(component, event, helper){
       helper.callEndpointTogetData(component, event, helper,true);
    },
    //pagination of next button and to get data from zyucs 
    onNextPageClick : function(component, event, helper){

        component.set("v.spinnerinQuickAction",true);
        component.set("v.currentPage",component.get("v.currentPage")+1);
        helper.onNextPageClick(component, event, helper);
    },
    //pagination of back button and to get data from zyucs 
    onBackPageClick : function(component, event, helper){
        component.set("v.spinnerinQuickAction",true);
        component.set("v.currentPage",component.get("v.currentPage")-1);
        helper.onBackPageClick(component, event, helper);
    },
    //Validation for filter search
    searchContractOwnerFromAPI : function(component, event, helper){
        
        component.set("v.currentPage",1);
       if(component.get("v.filterSelctedType")!='select'){
           if(component.get("v.searchVal")!="" && component.get("v.searchVal").length>=3 && component.get("v.searchVal")!=undefined){
              
           component.set("v.spinnerinQuickAction",true);  
           helper.callEndpointTogetData(component, event, helper,false);     
           component.set("v.defaultcondata",false);     
                
          }else{
              alert($A.get("$Label.c.Min_3_char_enter_for_CP_CO_search_error_msg"));
          }
        
       }
    },
    //To get all contract owners from zycus
    searchAllContractOwner : function(component, event, helper){
        component.set("v.spinnerinQuickAction",true);
        component.set("v.currentPage",1);
        component.set("v.searchVal","");
        component.set("v.filterSelctedType","select");
        helper.callEndpointTogetData(component, event, helper,true); 
        component.set("v.defaultcondata",true); 
    },
    //asc sort based on email
    sortEmailASC : function(component, event, helper){
      var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (a.contractOwner.email > b.contractOwner.email) ? 1 : ((b.contractOwner.email > a.contractOwner.email) ? -1 : 0);} );
      component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon);
    },
    //dsc sort based on email
    sortEmailDESC : function(component, event, helper){
        var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (b.contractOwner.email > a.contractOwner.email) ? 1 : ((a.contractOwner.email > b.contractOwner.email) ? -1 : 0);} );
       component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon); 
    },
    //asc sort based on Lastname
    sortLastNameASC : function(component, event, helper){
        var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (a.contractOwner.lastName > b.contractOwner.lastName) ? 1 : ((b.contractOwner.lastName > a.contractOwner.lastName) ? -1 : 0);} );
      component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon);
    },
    //ssc sort based on lastname
    sortLastNameDESC : function(component, event, helper){
         var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (b.contractOwner.lastName > a.contractOwner.lastName) ? 1 : ((a.contractOwner.lastName > b.contractOwner.lastName) ? -1 : 0);} );
       component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon); 
    },
    //asc sort based on firstname
    sortFirstNameASC : function(component, event, helper){
        var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (a.contractOwner.firstName > b.contractOwner.firstName) ? 1 : ((b.contractOwner.firstName > a.contractOwner.firstName) ? -1 : 0);} );
      component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon);
    },
    //dsc sort based on firstname
    sortFirstNameDESC : function(component, event, helper){
         var contractdataFrmIcon =  component.get("v.contractOwnerDataFromIcont");  
      contractdataFrmIcon.sort(function(a,b) {return (b.contractOwner.firstName > a.contractOwner.firstName) ? 1 : ((a.contractOwner.firstName > b.contractOwner.firstName) ? -1 : 0);} );
       component.set("v.contractOwnerDataFromIcont",contractdataFrmIcon); 
    },
    //on seleting a contract owner
    selectContractOwner:function(component, event, helper){
         var selectedConData		= event.getSource().get("v.value");
       
        component.set("v.contractOwnerFirstNameAndLastName",selectedConData.firstName+' '+selectedConData.lastName);
        component.getEvent("PassContractOwnerDetailsEvnt").setParams({"contractOwnerSelectedData" : selectedConData}).fire();

    },
    closePoppup:function(component, event, helper){
        document.getElementById("contractOwnerError").style.display = "none" ;
    }
})