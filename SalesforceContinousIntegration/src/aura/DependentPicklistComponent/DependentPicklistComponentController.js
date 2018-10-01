({
 
   doInit: function(component, event, helper) {
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
      helper.fetchPicklistValues(component, component.get("v.controllingField"), component.get("v.dependentField"));
   },
 
 
   // function call on change tha controller field  
   onControllerFieldChange: function(component, event, helper) {

      component.set("v.selectedControllingFieldValue" ,event.getSource().get("v.value"));
      
      var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') {
 
         // get dependent values for controller field by using map[key].  
         // for i.e "India" is controllerValueKey so in the map give key Name for get map values like 
         // map['India'] = its return all dependent picklist values.
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields);
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('conState').set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
      }
   },
 
   // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
      debugger;
      component.set("v.selectedDependentFieldValue" ,event.getSource().get("v.value"));
      
      var PickListEvent = component.getEvent("PickListEvt");
      PickListEvent.setParams({
         "controllingFieldValue":component.get("v.selectedControllingFieldValue"),
         "dependentFieldValue":component.get("v.selectedDependentFieldValue")
      });
      PickListEvent.fire();
      alert('dependent picklist event fired');

   }
})