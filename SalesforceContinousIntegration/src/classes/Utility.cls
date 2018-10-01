public with sharing class Utility {

    /*****************************************
    Purpose     : Method for getting Record Type Id                                  
    Return Type : Record Id
    *****************************************/
    public static Id getRecordTypeId(String objectType,String recordTypeName){
        Id recTypeId = Schema.getGlobalDescribe().get(objectType).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return recTypeId ;      
    }
    
    /*****************************************
    Purpose     : Get's Picklist field values of specified object    
    Param       : @ObjectApi_name is sObject API Name and @Field_name is the field API Name for 
                  which picklist values needed
    Return Type : List<String>
    *****************************************/
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
            
        }
        return lstPickvals;
    }
    
    
    public static String getDynamQuery(String objectAPIName , String criteria){
        Map<String, Schema.SObjectField> StagingCustomerFieldMap;
        sObjectType ObjectSchema            = schema.getGlobalDescribe().get(objectAPIName);        
        StagingCustomerFieldMap             = objectSchema.getDescribe().fields.getMap();
        
        //Construct generic query string used to query 'objectAPIName' data dynamically
        String query   = 'Select ';
        
        for(Schema.SObjectField s : StagingCustomerFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from ' + objectAPIName +' where ' +  criteria ;
        return query;
    }
    
    
    public static String convertFromByte(Decimal noOfBytes){
        if((noOfBytes / 1048576) >= 1){
            noOfBytes 	= (noOfBytes/ 1048576).setScale(2);
            return String.valueOf(noOfBytes) + ' Mb';
        }else if((noOfBytes / 1024) >= 1){
            noOfBytes 	= (noOfBytes / 1024).setScale(2);
            return String.valueOf(noOfBytes) + ' Kb';
        }else{
            noOfBytes 	= noOfBytes.setScale(2);
            return String.valueOf(noOfBytes) + ' B';
        }
    }
    
    
    public static void createPayLoadRecord(String req, String resp, Decimal callCount, String recordId, String entityType, 
                                           String eventDesc, String eventType, String status, String functionType,
                                           String errMsg, String payOutId){
        PayLoad__c payLoadObj 				= new PayLoad__c();
        payLoadObj.API_Request__c 			= req;
        payLoadObj.API_Response__c 			= resp;
        payLoadObj.CalloutCount__c 			= callCount;
        payLoadObj.Contract_Number__c 		= recordId;
        payLoadObj.Entity_Type__c 			= entityType;
        payLoadObj.Event_Description__c 	= eventDesc;
        payLoadObj.Event_Type__c 			= eventType;
        payLoadObj.Status__c 				= status;
        payLoadObj.Error_Message__c 		= errMsg;
        payLoadObj.Function_Type__c 		= functionType;
        if(String.isNotBlank(payOutId)) payLoadObj.Id 	= payOutId;
        upsert payLoadObj;
    }
}