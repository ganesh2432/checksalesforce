({
	greet : function(component) {
        var action = component.get("c.getName");
         action.setParams({ name : component.get("v.name") }); 
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 // Set name of  user as output
			 var output=response.getReturnValue();
             
			 component.set("v.output",output); 
                 }
             else if (state === "INCOMPLETE") {
                 //do Something
             }
            else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + errors[0].message);
                         }
                     } else {
                          console.log("Unknown error");
                     }
            }

          } );
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
				
	}
})