<!-- ********************************************************************************
 * Description :   This Lightning application Used to display components in classic view
 * Created By  :   Jayanth B
 * Created Date:   27/07/2018
 * Version     :   V1.0
*************************************************************************************** -->
<aura:application extends="ltng:outApp" access="global">
    
    <aura:handler name="init" value="{!this}" action="{!c.checkBaseURL}"/>
    
 <div class="slds-box" style="background-color: white;margin-left:3%; min-height: 100%;height: auto;">    
 <!--c:EditContractCoomponent/--><c:CreateContractValidationCheck/>
 </div>
</aura:application>