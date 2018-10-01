({
	doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    
    // for new field creation redirect url
    onFieldSelectChange : function(component, event, helper){
        var selValue = event.getSource().get("v.value");
        if(selValue == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
        	document.getElementById("redirectToFieldCreation").style.display = "block" ;     
        }
    },
    
    onModalCancel : function(component, event, helper){
        var resettingCreateToSelect = [];
        resettingCreateToSelect = component.get("v.lineItemData");
        var k=0;
        for(var i=0;i<resettingCreateToSelect.length;i++){
            if(resettingCreateToSelect[i].mappingField1 == $A.get("$Label.c.Create_New_Field_Object_Mapping_Component")){
                resettingCreateToSelect[i].mappingField1 = $A.get("$Label.c.Select_Field_Object_Mapping_Component");
                k=k+1;
            }
        }
        if(k!=0){
            component.set("v.lineItemData",resettingCreateToSelect);
        }
        document.getElementById("redirectToFieldCreation").style.display = "none" ;
    },
    
    // for new field creation redirect url
    onModalConfirm : function(component, event, helper){
        
            component.set("v.isNewFieldCreate",true);
            helper.saveRecords(component, event, helper);
        
    },
    
    // to save the mapping
    saveRecords : function(component, event, helper){
        helper.saveRecords(component, event, helper);
    },
    
    // field mismatch model display cancl
    onFieldMismatchModalCancel : function(component, event, helper){
        document.getElementById("FieldMismatchErrorMessageModal").style.display = "none" ;
    }
  
})