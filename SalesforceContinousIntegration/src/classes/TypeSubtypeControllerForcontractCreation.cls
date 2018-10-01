/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   11/09/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public class TypeSubtypeControllerForcontractCreation {

    // Gets the list of enabled and disabled type subtype values
    @AuraEnabled 
    public static String getTypeAndSubTypeMap(String OppId){
          return TypeSubtypeForcontractCreationHelper.prepareTypeAndSubTypeMap(OppId);        
    }
}