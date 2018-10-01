/*
* @Author         		: Rahul Sangwan
* Created By     		  : Rahul Sangwan (30/04/2018)
* Last Modified By   	: Rahul Sangwan (31/05/2018)
* @Description    		: Controller for IContractTypeSubTypeComponent
*/
public with sharing class TypeSubtypeController {

	//Variable used for stopping Second call of API in same execution.
    public static Boolean isSecondCall ;
    

    //Purpose : To find all Type and Subtype combination from IContract API.
  	//			It will call API and store the results in Mapping_Configurations__c object, 
  	//			and then get latest Active Type and Subtype combinations. 
  	//Return Type : Map<String, List<String>> , where key is Type and value is List of all subtypes
  	//				and particular Type.
    @AuraEnabled 
    public static Map<String, List<String>> getTypeAndSubTypeMap(){
        if(isSecondCall != true)
        TypeAndSubtypeFetchAPI.typeAndSubtypeCallout();
        isSecondCall	= true;
		return TypeSubtypeControllerService.prepareTypeAndSubTypeMap();        
    }
}