({
	checkboxSelect: function(component, event, helper) {
      // get the selected checkbox value  
      var selectedRec = event.getSource().get("v.value");
      // get the selectedCount attrbute value(default is 0) for add/less numbers. 
      var getSelectedNumber = component.get("v.selectedCount");
      // check, if selected checkbox value is true then increment getSelectedNumber with 1 
      // else Decrement the getSelectedNumber with 1     
      if (selectedRec == true) {
       getSelectedNumber++;
      } else {
       getSelectedNumber--;
      }
      // set the actual value on selectedCount attribute to show on header part. 
      component.set("v.selectedCount", getSelectedNumber);
      var compEvent = component.getEvent("selectedFieldCountEvt");
      compEvent.setParams({"selectedFieldCount" : component.get("v.selectedCount")});                
      compEvent.fire();  
        
        
    },
    
    
    selectAll: function(component, event, helper) {
      //get the header checkbox value  
  //    debugger;
      var selectedHeaderCheck = event.getSource().get("v.value");
      // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
      // return the List of all checkboxs element 
      var getAllId = component.find("boxPack");
      // If the local ID is unique[in single record case], find() returns the component. not array   
         if(! Array.isArray(getAllId)){
           if(selectedHeaderCheck == true){ 
              if(component.find("boxPack").get("v.disabled") == false){
                component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", 1);  
              }            
           }else{
              if(component.find("boxPack").get("v.disabled") == false){
                component.find("boxPack").set("v.value", false);
                component.set("v.selectedCount", 0);  
              }
           }
         }else{
           // check if select all (header checkbox) is true then true all checkboxes on table in a for loop  
           // and set the all selected checkbox length in selectedCount attribute.
           // if value is false then make all checkboxes false in else part with play for loop 
           // and select count as 0 
            if (selectedHeaderCheck == true) {
            for (var i = 0; i < getAllId.length; i++) {
              if(component.find("boxPack")[i].get("v.disabled") == false){
                component.find("boxPack")[i].set("v.value", true);
                component.set("v.selectedCount", getAllId.length);
              }
            }
            } else {
              for (var i = 0; i < getAllId.length; i++) {
                if(component.find("boxPack")[i].get("v.disabled") == false){
                  component.find("boxPack")[i].set("v.value", false);
                  component.set("v.selectedCount", component.get("v.selectedCount") - 1);
                }
            }
           } 
         }
         var compEvent = component.getEvent("selectedFieldCountEvt");
         compEvent.setParams({"selectedFieldCount" : component.get("v.selectedCount")});                
         compEvent.fire();  
     
     },
    
    
     goNext:function(component,event,helper){
         var allContatcts = component.get("v.ListOfContact");
         var selectedContatcs = [];
   //      debugger;
         var selectedCount 	= component.get("v.selectedCount");
         if(selectedCount < 1){
   //       debugger;
            component.set("v.fieldSelErrMsg", $A.get("$Label.c.Select_atleast_one_field_Err_Msg_Field_Selection"));
            document.getElementById("FieldSelectionSubmitErrMsgModel").style.display = "block" ;
         }else{
         	component.set("v.isNextVisible",true);
         for(var i=0;i<allContatcts.length;i++){
             if(allContatcts[i].isSelected == true){
              //   console.log(allContatcts[i]);
                 selectedContatcs.push(allContatcts[i]);
             }
         }
    //     console.log(selectedContatcs);
         var selectedContatcsStr = JSON.stringify(selectedContatcs);
  //       debugger;
         var action = component.get("c.createFieldsMetadata");
         action.setParams({
            "selType": component.get("v.selectedType"),
            "selSubType": component.get("v.selectedSubType"),
            "fieldSelectedData": selectedContatcsStr
        }); 
        component.set("v.Spinner", true);
        action.setCallback(this, function(a) {
      //      debugger;
            var res = a.getReturnValue();
            if(res.includes("Exception")){
              component.set("v.Spinner", false);    
            }else{
                component.set("v.Spinner", false);
                var compEvent = $A.get("e.c:MovetoNextProgressBarEvt");
                compEvent.setParams({"movetoStep" : "step2", "mappingConfigId" : res})                
                compEvent.fire();
                
                var selFieldsEvent = $A.get("e.c:SelectedFieldsEvt");
                selFieldsEvent.setParams({"slectedIcontractField" : selectedContatcs})                
                selFieldsEvent.fire();
            }

        });
        $A.enqueueAction(action);                   
         }
         
     },


     closeSelectionErrModal : function(component, event, helper){
        document.getElementById("FieldSelectionSubmitErrMsgModel").style.display = "none" ;      
     },


     goToHomePage : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "none" ;
       component.getEvent("goToHomePage").fire();
    },


    ExitConfigurationModel : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "block" ; 
    },


    CloseExitConfigurationModel : function(component, event,helper){
       document.getElementById("ExitConfigurationModel").style.display = "none" ; 
    }
})