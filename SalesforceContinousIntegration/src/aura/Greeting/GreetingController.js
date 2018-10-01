({  
    doInit: function(component, event, helper) {
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
      var input = component.find('getInput');
      $A.util.addClass(input, 'name');
      
   },
    greet:function(component, event, helper) {
        helper.greet(component);
    },
    clear:function(component, event, helper) {
        component.set("v.output","");  
    }
})