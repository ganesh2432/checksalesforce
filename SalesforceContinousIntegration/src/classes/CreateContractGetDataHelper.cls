/*----------------------------------------------------------------------------
* Description :   This helper is used for document setup
* Created By  :   Jayanth B
* Created Date:   09/10/2018
* Version     :   V1.0
---------------------------------------------------------------------------*/
public with sharing class CreateContractGetDataHelper {
    
    //used to get details of contract owner and contract party during Edit of contract through request wizard 
    public static Contract getcontractOwnerdata(String contrctid){
        Contract contrct = [Select id,ContractOwnerEmail__c,ContractOwnerFirstName__c,Allow_Opportunity_LineItem_s__c,ContractOwnerLastName__c,ContractOwnerUserId__c,Contract_Party_address__c,Contract_Party_CompanyName__c,Contract_Party_contractingPartyGsid__c,Contract_Party_ExternalId__c,ContractParty_LegalName__c from contract where id=:contrctid];   
        return contrct;
    }
    
    //used to get details to edit contract from contract record by whos fields which are mapped in icontractmapping config
    public static String getEditContractDetails(String contrctid,String selectedType,String selectedSubType){
        try{     
            // Works for any SObjectType
            SObjectType sobType = Contract.SObjectType;
            
            Map<String,String> apiFieldNameAndRecordValue = new Map<String,String>();
            List<String> fields = new List<String>(sobType.getDescribe().fields.getMap().keySet());
            //Creating a map of all the fields present under contract with its field value for the specified contract record
            for (SObject sob : Database.query(''
                                              + ' select ' + String.join(fields, ',')
                                              + ' from ' + sobType + ' Where id=:contrctid'
                                              + ' limit 1'
                                             )) {
                                                 for (String field : fields) {
                                                     Object value = sob.get(field);
                                                     if (value != null){
                                                         apiFieldNameAndRecordValue.put(field.toLowercase(), String.valueOf(value));
                                                     }else{
                                                         apiFieldNameAndRecordValue.put(field.toLowercase(), '');
                                                     }
                                                 }
                                             }
            
            
            //query all the questions from Request wizard for the specified type and subtype
            List<Request_Wizard_MetaData__c> requestWizardData     = [Select id,Field_Name__c,IContract_Field_Metadata__r.SOT__c,IContract_Field_Metadata__r.Mandatory__c,IContract_Field_Metadata__r.Field_Name__c,IContract_Field_Metadata__c,IContract_Field_Metadata__r.DataType__c,IContract_Field_Metadata__r.Mapping_Object_2__c,IContract_Field_Metadata__r.Mapping_Object__c,IContract_Field_Metadata__r.Mapping_Field__c,IContract_Field_Metadata__r.Mapping_Field_2__c,Order_No__c,Question__c From Request_Wizard_MetaData__c Where Type__c=:selectedType AND SubType__c=:selectedSubType Order by Order_No__c ASC];
            List<RequestWizardQueAnsWrp> reqWzrdQueAndAnsWrpList   = new List<RequestWizardQueAnsWrp>();
            
            set<string> icontractIds = new set<String>();
            
            
            for(Request_Wizard_MetaData__c reqwz : requestWizardData){
                icontractIds.add(reqwz.IContract_Field_Metadata__c);
            }
            
            List<Value_Mapping__c> valueMappingList = [Select id,Field_Name__c,Mapping_Value2__c,IContract_Field_Metadata__c,Mapping_Object2__c,Mapping_Value__c,Mapping_Field2__c,IContract_Value__c from Value_Mapping__c where IContract_Field_Metadata__c=:icontractIds];
            Map<String,List<String>> picklistVals = new Map<String,List<String>>();
            Map<String,String> selectedAnswerOrVal = new Map<String,String>();
            
            for(Value_Mapping__c vmp : valueMappingList){
                if(!picklistVals.containsKey(vmp.Field_Name__c)){
                    picklistVals.put(vmp.Field_Name__c,new List<String>{vmp.Mapping_Value__c});
                }else{
                    picklistVals.get(vmp.Field_Name__c).add(vmp.Mapping_Value__c); 
                }
                
                if(!selectedAnswerOrVal.containsKey(vmp.Field_Name__c)){
                    selectedAnswerOrVal.put(vmp.Field_Name__c+'@@'+vmp.Mapping_Value__c,vmp.Mapping_Value__c); 
                }
                
            }
            
            //Creating a wrapper of question from request wizard followed by values for the 
            //particular fields under contract based on each datatype of the fields
            for(Request_Wizard_MetaData__c reqwz : requestWizardData){
                
                RequestWizardQueAnsWrp wrp = new RequestWizardQueAnsWrp();
                
                wrp.orderno = Integer.valueOf(reqwz.Order_No__c);
                wrp.question = reqwz.Question__c;
                wrp.fieldName = reqwz.Field_Name__c;
                wrp.objName2 = reqwz.IContract_Field_Metadata__r.Mapping_Object_2__c;
                wrp.mandatory = reqwz.IContract_Field_Metadata__r.Mandatory__c;
                //used to get field length
                wrp.fieldLength = Schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap().get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase()).getDescribe().getlength(); 
                
                if(reqwz.IContract_Field_Metadata__r.SOT__c == Constants.icontract_SOT){
                    wrp.iContractSot = true;
                }
                
                if(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c!=null){
                    wrp.mappedFieldName2 = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase();
                }else{
                    wrp.mappedFieldName2 = '';    
                }
                
                //used to get the datatype of the field
                String objectName = reqwz.IContract_Field_Metadata__r.Mapping_Object__c;
                String fieldName = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase();
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                
                if(reqwz.IContract_Field_Metadata__r.Mapping_Field__c!=null){
                    wrp.answer = apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase());
                    wrp.mappedFieldName1 = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase();
                    wrp.datatype = String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()).toLowercase();
                }else{
                    wrp.answer = '';
                    wrp.mappedFieldName1 = ''; 
                    wrp.datatype = '';    
                }
                
                
                if(wrp.datatype == 'picklist'){
                    wrp.picklistValuestodisplay = picklistVals.get(reqwz.IContract_Field_Metadata__r.Field_Name__c);
                    if(reqwz.IContract_Field_Metadata__r.Mapping_Field__c!=null){
                        if(selectedAnswerOrVal.containsKey(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase())))
                            wrp.answer = selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase()));
                        else
                            wrp.answer = '';//remove if values needs to be removed    
                    }
                }
                // for multi picklist do different
                if(wrp.datatype == 'multipicklist'){
                    wrp.picklistValuestodisplay = picklistVals.get(reqwz.IContract_Field_Metadata__r.Field_Name__c);
                    if(reqwz.IContract_Field_Metadata__r.Mapping_Field__c!=null){
                        List<String> valueFromcon = new List<String>();
                        String answerStr = ''; 
                        for(String s : apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase()).split(';')){
                            if(selectedAnswerOrVal.containsKey(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s)){
                                valueFromcon.add(selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s));   
                            } 
                            if(answerStr == ''){
                                answerStr = answerStr + selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s);
                            }else{
                                answerStr = answerStr +',' + selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s); 
                            }
                        }
                        wrp.answerListForMultiSelect = valueFromcon;
                        wrp.answer = answerStr;
                        //wrp.answerListForMultiSelect = apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase()).split(';');
                    }   
                }
                
                wrp.objName1 = reqwz.IContract_Field_Metadata__r.Mapping_Object__c;
                reqWzrdQueAndAnsWrpList.add(wrp);
            }
            
            return json.serialize(reqWzrdQueAndAnsWrpList);
            
            //return null;
        }catch(Exception e){ 
            HandleBusinessException.captureError('CreateContractGetDataController', 'getEditContractDetails', e);
            return 'Exception';
        }
        
    }
    
     //used to get details to create contract from opp record by whos fields which are mapped in icontractmapping config
    @AuraEnabled
    public static String getContractDetails(String oppId,String selectedType,String selectedSubType){
        try{       
            // Works for any SObjectType
            SObjectType sobType = Opportunity.SObjectType;
            
            Map<String,String> apiFieldNameAndRecordValue = new Map<String,String>();
            List<String> fields = new List<String>(sobType.getDescribe().fields.getMap().keySet());
            for (SObject sob : Database.query(''
                                              + ' select ' + String.join(fields, ',')
                                              + ' from ' + sobType + ' Where id=:OppId'
                                              + ' limit 1'
                                             )) {
                                                 for (String field : fields) {
                                                     Object value = sob.get(field);
                                                     if (value != null){
                                                         apiFieldNameAndRecordValue.put(field.toLowercase(), String.valueOf(value));
                                                     }else{
                                                         apiFieldNameAndRecordValue.put(field.toLowercase(), '');
                                                     }
                                                 }
                                             }
            
            
            //query all the questions from Request wizard for the specified type and subtype
            List<Request_Wizard_MetaData__c> requestWizardData     = [Select id,Field_Name__c,IContract_Field_Metadata__r.Mandatory__c,IContract_Field_Metadata__r.Field_Name__c,IContract_Field_Metadata__c,IContract_Field_Metadata__r.DataType__c,IContract_Field_Metadata__r.Mapping_Object_2__c,IContract_Field_Metadata__r.Mapping_Object__c,IContract_Field_Metadata__r.Mapping_Field__c,IContract_Field_Metadata__r.Mapping_Field_2__c,Order_No__c,Question__c From Request_Wizard_MetaData__c Where Type__c=:selectedType AND SubType__c=:selectedSubType Order by Order_No__c ASC];
            List<RequestWizardQueAnsWrp> reqWzrdQueAndAnsWrpList   = new List<RequestWizardQueAnsWrp>();
            
            set<string> icontractIds = new set<String>();
            
            
            for(Request_Wizard_MetaData__c reqwz : requestWizardData){
                icontractIds.add(reqwz.IContract_Field_Metadata__c);
            }
            
            
            List<Value_Mapping__c> valueMappingList = [Select id,Field_Name__c,Mapping_Value2__c,IContract_Field_Metadata__c,Mapping_Object2__c,Mapping_Value__c,Mapping_Field2__c,IContract_Value__c from Value_Mapping__c where IContract_Field_Metadata__c=:icontractIds];
            Map<String,List<String>> picklistVals = new Map<String,List<String>>();
            Map<String,String> selectedAnswerOrVal = new Map<String,String>();
            
            for(Value_Mapping__c vmp : valueMappingList){
                if(!picklistVals.containsKey(vmp.Field_Name__c)){
                    picklistVals.put(vmp.Field_Name__c,new List<String>{vmp.Mapping_Value__c});
                }else{
                    picklistVals.get(vmp.Field_Name__c).add(vmp.Mapping_Value__c); 
                }
                
                if(!selectedAnswerOrVal.containsKey(vmp.Field_Name__c)){
                    selectedAnswerOrVal.put(vmp.Field_Name__c+'@@'+vmp.Mapping_Value2__c,vmp.Mapping_Value__c); 
                }
                
            }
            
            
            //Creating a wrapper of question from request wizard followed by values for the 
            //particular fields under opportunity based on each datatype of the fields
            for(Request_Wizard_MetaData__c reqwz : requestWizardData){
                
                RequestWizardQueAnsWrp wrp = new RequestWizardQueAnsWrp();
                
                wrp.orderno = Integer.valueOf(reqwz.Order_No__c);
                wrp.question = reqwz.Question__c;
                wrp.fieldName = reqwz.Field_Name__c;
                wrp.objName2 = reqwz.IContract_Field_Metadata__r.Mapping_Object_2__c;
                wrp.mandatory = reqwz.IContract_Field_Metadata__r.Mandatory__c;
                //used to get field length
                wrp.fieldLength = Schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap().get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase()).getDescribe().getlength(); 
                
                
                
                if(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c!=null){
                    wrp.answer = apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase());
                    wrp.mappedFieldName2 = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase();
                }else{
                    wrp.answer = ''; 
                    wrp.mappedFieldName2 = '';    
                }
                
                //used to get datatype
                String objectName = reqwz.IContract_Field_Metadata__r.Mapping_Object__c;
                String fieldName = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase();
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                
                if(reqwz.IContract_Field_Metadata__r.Mapping_Field__c!=null){
                    wrp.mappedFieldName1 = String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field__c).toLowercase();
                    wrp.datatype = String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()).toLowercase();
                }else{
                    wrp.mappedFieldName1 = ''; 
                    wrp.datatype = '';    
                }
                
                
                if(wrp.datatype == 'picklist'){
                    wrp.picklistValuestodisplay = picklistVals.get(reqwz.IContract_Field_Metadata__r.Field_Name__c);
                    if(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c!=null){
                        if(selectedAnswerOrVal.containsKey(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase())))
                            wrp.answer = selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase()));
                        else
                            wrp.answer = '';//remove if values needs to be removed    
                    }
                }
                // for multi picklist do different
                if(wrp.datatype == 'multipicklist'){
                    wrp.picklistValuestodisplay = picklistVals.get(reqwz.IContract_Field_Metadata__r.Field_Name__c);
                    if(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c!=null){
                        List<String> valueFromcon = new List<String>();
                        String answerStr = ''; 
                        for(String s : apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase()).split(';')){
                            if(selectedAnswerOrVal.containsKey(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s)){
                                valueFromcon.add(selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s));   
                            } 
                            if(answerStr == ''){
                                answerStr = answerStr + selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s);
                            }else{
                                answerStr = answerStr +',' + selectedAnswerOrVal.get(reqwz.IContract_Field_Metadata__r.Field_Name__c+'@@'+s); 
                            }
                        }
                        wrp.answerListForMultiSelect = valueFromcon;
                        wrp.answer = answerStr;
                        //wrp.answerListForMultiSelect = apiFieldNameAndRecordValue.get(String.valueOf(reqwz.IContract_Field_Metadata__r.Mapping_Field_2__c).toLowercase()).split(';');
                    }   
                }
                
                wrp.objName1 = reqwz.IContract_Field_Metadata__r.Mapping_Object__c;
                reqWzrdQueAndAnsWrpList.add(wrp);
            }
            //return 'Exception';
            return json.serialize(reqWzrdQueAndAnsWrpList);
        }Catch(Exception e){
            HandleBusinessException.captureError('CreateContractGetDataController', 'getContractDetails', e);
            return 'Exception';
        }
        
    }
    
    //used to create contract data sent throught request wizard
    public static String createContractData(String contrctId,String oppId, String stageStr,String selectedType,String selectedSubType){
        try{
            Opportunity opp = new opportunity();
            List<DataToCreateContract> contractData = (List<DataToCreateContract>)JSON.deserialize(stageStr,List<DataToCreateContract>.class);
            
            Contract insertcontractRecd = new Contract();
            
            //if contract is present
            if(contrctId!=null && contrctId!=''){
                insertcontractRecd.put('Id',contrctId);
            }
            
            insertcontractRecd.put('Type__c',selectedType);
            insertcontractRecd.put('SubType__c',selectedSubType);
            insertcontractRecd.put('Is_RequestWizard_Contract__c',true);
            insertcontractRecd.put('IContract_Status__c',Constants.SFDC_icontract_status);
            
            //if opp is present
            if(oppId!=null && oppId!=''){
                opp = [Select id,AccountId  from Opportunity where id=:oppId];
                if(opp.AccountId!=null){
                    insertcontractRecd.put('Opportunity__c',opp.Id);
                    insertcontractRecd.put('AccountId',opp.AccountId);
                }else{
                    return 'There is no Account attached to this opportunity!';
                }
                
            }
            
            
            //used to convert the wrapper to contract obj record to upsert by converting to respective datatype
            for(DataToCreateContract dataCrtcontr : contractData){
                       
                if(dataCrtcontr.datatype == 'currency' || dataCrtcontr.datatype == 'double' || dataCrtcontr.datatype == 'percent' || dataCrtcontr.datatype == 'decimal'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,null);    
                    }else{
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,decimal.valueOf(dataCrtcontr.FieldValue));
                    }
                }
                else if(dataCrtcontr.datatype == 'integer'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,null);    
                    }else{
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,integer.valueOf(dataCrtcontr.FieldValue));
                    }
                }
                else if(dataCrtcontr.datatype=='boolean'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,false);    
                    }else{
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,boolean.valueOf(dataCrtcontr.FieldValue));
                    }  
                }
                else if(dataCrtcontr.datatype=='date'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,null);    
                    }else{
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,date.valueOf(dataCrtcontr.FieldValue));
                    }     
                }
                else if(dataCrtcontr.datatype=='multipicklist'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,null);    
                    }else{
                        String Multipicklistvalsetup = String.valueOf(dataCrtcontr.FieldValue).replace(',', ';');
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,Multipicklistvalsetup);
                    } 
                    
                }
                else if(dataCrtcontr.datatype=='datetime'){
                    if(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null'){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,null);    
                    }else{
                        // DateTime dt = (DateTime) JSON.deserialize(dataCrtcontr.FieldValue, DateTime.class);
                        // System.debug(dt); // 2016-03-03 06:09:36 
                        // String formatedDate = dt.format('MM/dd/yyyy HH:mm'); // 03/03/2016 01:09    
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,Datetime.valueOf(dataCrtcontr.FieldValue.split('\\.')[0].replace('T',' ')));
                    } 
                }
                else{
                    // for picklist,string,text,teaxtarea,textarearich,textarealong,url,email,phone
                    if(!(dataCrtcontr.FieldValue == '' || dataCrtcontr.FieldValue == null || dataCrtcontr.FieldValue == 'null')){
                        insertcontractRecd.put(dataCrtcontr.FieldApiName,String.valueOf(dataCrtcontr.FieldValue));
                    }
                }
                
            }
            if(insertcontractRecd!=null){
                upsert insertcontractRecd;
                
                if(opp.AccountId!=null){
                    Account accCPUpdate= new Account();
                    accCPUpdate.id= opp.AccountId;
                    accCPUpdate.ContractParty_LegalName__c = insertcontractRecd.ContractParty_LegalName__c;
                    accCPUpdate.Contract_Party_CompanyName__c = insertcontractRecd.Contract_Party_CompanyName__c;
                    accCPUpdate.Contract_Party_address__c = insertcontractRecd.Contract_Party_address__c;
                    accCPUpdate.Contract_Party_contractingPartyGsid__c = insertcontractRecd.Contract_Party_contractingPartyGsid__c;
                    accCPUpdate.Contract_Party_ExternalId__c =    insertcontractRecd.Contract_Party_ExternalId__c;
                    
                    update accCPUpdate;
                }
            }
            
            return String.valueOf(insertcontractRecd.id);
        }catch(Exception e){
            HandleBusinessException.captureError('CreateContractGetDataController', 'createContractData', e);
            return 'Exception'+e.getMessage();
        }
        
    }
    
    //wrapper to create contract
    public Class DataToCreateContract{
        @AuraEnabled
        public string FieldApiName {get;set;}
        @AuraEnabled
        public string FieldValue {get;set;}
        @AuraEnabled
        public string dataType {get;set;}
        
        public DataToCreateContract(){
            FieldApiName = '';
            FieldValue = '';
            dataType = '';
        }
    }
    
    //wrapper to display questions with answers form opp/contrct during create and edit
    public Class RequestWizardQueAnsWrp{
        @AuraEnabled
        public string question {get;set;}
        @AuraEnabled
        public string fieldName {get;set;}
        @AuraEnabled
        public Integer orderno {get;set;}
        @AuraEnabled
        public string answer {get;set;}
        @AuraEnabled
        public string objName1 {get;set;}
        @AuraEnabled
        public boolean mandatory {get;set;}
        @AuraEnabled
        public string mappedFieldName1 {get;set;}
        @AuraEnabled
        public string objName2 {get;set;}
        @AuraEnabled
        public string mappedFieldName2 {get;set;}
        @AuraEnabled
        public string datatype {get;set;}
        @AuraEnabled
        public List<string> picklistValuestodisplay {get;set;}
        @AuraEnabled
        public List<string> answerListForMultiSelect {get;set;}
        @AuraEnabled
        public Integer fieldLength {get;set;}
        @AuraEnabled
        public boolean iContractSot { get;set;}
        
        public RequestWizardQueAnsWrp(){
            question = '';
            fieldName = '';
            orderno = 0;
            answer = '';
            objName1 = '';
            mappedFieldName1='';
            objName2 = '';
            mappedFieldName2='';
            datatype = '';
            picklistValuestodisplay = new List<String>();
            answerListForMultiSelect = new List<String>();
            fieldLength = 0;
            iContractSot = false;
        }
    }
}