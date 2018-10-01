({
    //pagination of next button and to get data from zyucs 
    onNextPageClick : function(component, event, helper) {
        var defaultdatanext = component.get("v.defaultcPdata");
		this.callEndpointTogetCPData(component, event, helper,defaultdatanext);
	},
    //pagination of back button and to get data from zyucs
    onBackPageClick : function(component, event, helper) {
		var defaultdatanext = component.get("v.defaultcPdata");
		this.callEndpointTogetCPData(component, event, helper,defaultdatanext);
	},
    //callout to apex controller to get data from zycus org
	callEndpointTogetCPData : function(component, event, helper,onload){
		var action = component.get("c.getContractPartyData");
           action.setParams({"contracType":component.get("v.typeSelectedValue"),
                             "searchText":component.get("v.searchcpVal"),
                             "currentPage":component.get("v.currentCPPage"),
                             "isOnload":onload});
 
            debugger;
            action.setCallback(this,function(response){
                var response = response.getReturnValue();
                try{
                if(response !=null){
                var respobj = JSON.parse(response.body);
                var contractpartyDatass =  respobj.IntegrationEntities.integrationEntity[0].integrationEntityDetails.searchresult.result.resultEntities;
                
                
                var isListEmpty = false;
                if(contractpartyDatass!=undefined){
                    component.set("v.displayTable",true);
                    if(contractpartyDatass.length<20){
                    isListEmpty = false;
                }else{
                   isListEmpty = true; 
                }
					                
                var CpfilteredData = [];
                for(var i=0;i<contractpartyDatass.length;i++){
                    CpfilteredData.push({legalName:contractpartyDatass[i].contractingParty.legalName,
                                        companyType:contractpartyDatass[i].contractingParty.companyType,
                                       externalId:contractpartyDatass[i].contractingParty.externalId,
                                        contractingPartyGsid:contractpartyDatass[i].contractingParty.contractingPartyGsid,
                                        address:contractpartyDatass[i].contractingParty.addresses.addressDetails[0].city +', '+contractpartyDatass[i].contractingParty.addresses.addressDetails[0].country
                                        });
                }
                console.log(CpfilteredData);
                
                component.set("v.contractPartyDataList",CpfilteredData);
                }else{
                    component.set("v.displayTable",false);
                    //alert('CP(s) not available from Icontract.');
                }

                component.set("v.spinnerinQuickActionCP",false);
                component.getEvent("BackNextContractPartyEvnt").setParams({"currntpageno" : component.get("v.currentCPPage"),"stillDataExist":isListEmpty }).fire();
                
                }else{
                component.set("v.displayTable",false);    
                component.set("v.spinnerinQuickActionCP",false); 
                component.getEvent("BackNextContractPartyEvnt").setParams({"currntpageno" : component.get("v.currentCPPage"),"stillDataExist":false }).fire();    
                }
                }catch(e){
                component.set("v.spinnerinQuickActionCP",false);
                document.getElementById("contractpartyError").style.display = "block" ;
            }
                
            });       
            $A.enqueueAction(action);
	}
})