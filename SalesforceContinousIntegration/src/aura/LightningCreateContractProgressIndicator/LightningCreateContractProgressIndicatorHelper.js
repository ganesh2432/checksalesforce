({
    // used to redirect to opportunity detail page during creation of contract 
    // and redirect to contract detail page during edit of contract
	redirectToOppDetailPage : function(component,event,helper) {
		 // document.getElementById("canclePopUp").style.display = "none" ;
        $A.util.removeClass(component.find("canclePopUpconfirm"),"slds-show");
		$A.util.addClass(component.find("canclePopUpconfirm"),"slds-hide");
        
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)){
            // for lightning view
            var Opprec = '';
            if(component.get("v.scoperunningcreate")!=true){
            Opprec  = component.get("v.contractRecId");     
            }else{
            Opprec  = component.get("v.opportunityId");    
            }
            
            if(component.get("v.redirectToOppOndiscrd")==true)
                Opprec  = component.get("v.opportunityId");
            
            
            var sObectEvent = $A.get("e.force:navigateToSObject");
            sObectEvent .setParams({
                "recordId": Opprec  ,
                "slideDevName": "detail"
            });
            sObectEvent.fire();
        }else{
            //for classic view
            
            if(component.get("v.redirectToOppOndiscrd")==true){
            window.location.href = "/"+component.get("v.opportunityId");
             return;   
            }
            
            if(component.get("v.isEditing")==true){
                window.location.href = "/"+component.get("v.contractRecId"); 
            }else{
            window.location.href = "/"+component.get("v.opportunityId");    
            }
             
        }

	}
})