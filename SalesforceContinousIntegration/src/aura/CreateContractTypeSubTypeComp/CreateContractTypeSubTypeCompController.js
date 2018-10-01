({
    //onload function which defines in which environment the components are running and fetches the type and subtype values
    doInit : function(component, event, helper) {
        
        var locURL =  window.location.href;
        	var lightningURL = $A.get("$Label.c.Lightning_URL");
            if(locURL.includes(lightningURL)){
                component.set("v.themeURL", "Theme4d");
            }else{
                component.set("v.themeURL", "Theme3");  
            }
        
        if(component.get("v.opportunityId")!= undefined && component.get("v.opportunityId")!= null){
            helper.fetchPicklistValues(component);
        }
         
    },
    // used to create a contract default data by taking the values from opportunity fields where mapping was done in admin config is referred
    getContractData : function(component,event,helper){
       
        if(component.get("v.typeSelectedValue")=='Select'){
            component.set("v.subTypeSelectedValue","Select")
        }
        
        if(component.get("v.subTypeSelectedValue") == 'Select' || component.get("v.subTypeSelectedValue") == undefined ||component.get("v.subTypeSelectedValue") == null || component.get("v.typeSelectedValue") == 'Select' || component.get("v.typeSelectedValue") == undefined || component.get("v.typeSelectedValue") == null){
            alert($A.get("$Label.c.type_subtype_mand_error"));return;
        }else{
            
            if(component.get("v.themeURL")=="Theme4d"){    
                $A.get("e.force:closeQuickAction").fire();  
                
                var urlEvent = $A.get("e.force:navigateToComponent");  
            
                urlEvent.setParams({
                    componentDef: "c:LightningCreateContractProgressIndicator",
                    componentAttributes:{
                       
                        opportunityId:component.get("v.opportunityId"),
                        typeSelectedValue:component.get("v.typeSelectedValue"),
                        subTypeSelectedValue:component.get("v.subTypeSelectedValue"),
                        scoperunningcreate:true
                    }
                });
                urlEvent.fire();
            }else{
                component.set("v.openCreateContract",true);
            }
        }
    },
    onTypeFieldChange : function(component, event, helper) {
        helper.fetchSubTypeValues(component, event);
    },
    /*
    Purpose : To set the Subtype selected in subTypeSelectedValue attribute.
    */
    setSelectedSubTypeValue : function(component, event, helper) {
        var subTypeVal 	= event.getSource().get("v.value");
        if(subTypeVal != $A.get("$Label.c.NONE_Value_in_dropdown"))
            component.set("v.subTypeSelectedValue" ,event.getSource().get("v.value"));
        else
            component.set("v.subTypeSelectedValue" , '');
    }
})