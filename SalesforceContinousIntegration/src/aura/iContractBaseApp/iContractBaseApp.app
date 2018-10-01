<aura:application extends="force:slds" access="global">
    <aura:attribute type="Boolean" name="showLineItemMapping" default="false"/>
   
    <aura:handler name="EnableLineItemMappings" event="c:EnableLineItemMappings" action="{!c.EnableLineItemMappings}"/>
    <aura:handler name="goToHomePage" event="c:GoToHomePage" action="{!c.goToHomePage}"/>
    
    <aura:if isTrue="{!not(v.showLineItemMapping)}">
        <c:iContractBaseComponent aura:id="iContractBaseComp"/>
   </aura:if>
    <aura:if isTrue="{!v.showLineItemMapping}">
		<c:LightningProgressIndicatorForLineItemMapping />
	</aura:if>
</aura:application>