<!-- ********************************************************************************
 * Description :   This Lightning application used to diaplay the req wizard in classic environment
 * Created By  :   Jayanth B
 * Created Date:   18/07/2018
 * Version     :   V1.0
*************************************************************************************** -->
<aura:application extends="ltng:outApp" access="global">
    
    <aura:handler name="init" value="{!this}" action="{!c.checkBaseURL}"/>
    
 <div class="slds-box" style="background-color: white;margin-left:3%; min-height: 100%;height: auto;">    
 <c:CreateContractValidationCheck/>
 </div>
</aura:application>