/*----------------------------------------------------------------------------
* Description :   This controller is used for value mapping
* Created By  :   Jayanth B
* Created Date:   02/06/2018  
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class LineITemValueMappingController {

    public static list<String> getEnumListValues(String ObjectApiName,String FieldApiName){
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApiName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();        
        List<Schema.PicklistEntry> pick_list_values = field_map.get(FieldApiName).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) { 
        	lstPickvals.add(a.getValue());
        }
        return lstPickvals;
    }
}