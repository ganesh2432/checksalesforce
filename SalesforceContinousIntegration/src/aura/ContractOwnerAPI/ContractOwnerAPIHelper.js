({
    //pagination of next button and to get data from zyucs 
    onNextPageClick : function(component, event, helper) {
        var defaultdatanext = component.get("v.defaultcondata");
        this.callEndpointTogetData(component, event, helper,defaultdatanext);
    },
    //pagination of back button and to get data from zyucs
    onBackPageClick : function(component, event, helper) {
        var defaultdatanext = component.get("v.defaultcondata");
        this.callEndpointTogetData(component, event, helper,defaultdatanext);
    },
    //callout to apex controller to get data from zycus org
    callEndpointTogetData : function(component, event, helper, onload){
        
        
        var action = component.get("c.getContractOwnerData");
        action.setParams({"contracType":component.get("v.typeSelectedValue"),
                          "searchBy":component.get("v.filterSelctedType"),
                          "searchText":component.get("v.searchVal"),
                          "currentPage":component.get("v.currentPage"),
                          "isOnload":onload});
        
        action.setCallback(this,function(response){
            var response = response.getReturnValue();
            try{
                if(response !=null){
                    
                    var respobj = JSON.parse(response.body);
                    var contractOwnerDatass =  respobj.IntegrationEntities.integrationEntity[0].integrationEntityDetails.searchresult.result.resultEntities;
                    
                    component.set("v.contractOwnerDataFromIcont",contractOwnerDatass);
                    console.log(component.get("v.contractOwnerDataFromIcont"));
                    var isListEmpty = false;
                    
                    if(contractOwnerDatass != undefined){
                        component.set("v.displayTable",true);
                        if(contractOwnerDatass.length<20){
                            isListEmpty = false;
                        }else{
                            isListEmpty = true; 
                        }
                    }else{
                        component.set("v.displayTable",false);
                    }
                    
                    component.set("v.spinnerinQuickAction",false);
                    component.getEvent("BackNextContractOwnerEvnt").setParams({"currntpageno" : component.get("v.currentPage"),"stillDataExist":isListEmpty }).fire();
                }else{
                    component.set("v.displayTable",false);    
                    component.set("v.spinnerinQuickAction",false); 
                    component.getEvent("BackNextContractOwnerEvnt").setParams({"currntpageno" : component.get("v.currentPage"),"stillDataExist":false }).fire();    
                }
            }catch(e){
                component.set("v.spinnerinQuickAction",false);
                document.getElementById("contractOwnerError").style.display = "block" ;
            }
        });       
        $A.enqueueAction(action);
    }
})