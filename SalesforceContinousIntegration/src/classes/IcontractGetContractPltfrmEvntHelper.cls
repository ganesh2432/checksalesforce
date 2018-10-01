public class IcontractGetContractPltfrmEvntHelper {
    
    public static void getcontractpltfrmEvnt(List<GetContract__e> evntContrctdata){
        calloutToGetcontractData(String.valueOf(evntContrctdata[0].Contract_Number__c),
                                 String.valueOf(evntContrctdata[0].Entity_Type__c),
                                 String.valueOf(evntContrctdata[0].Event_Description__c),
                                 String.valueOf(evntContrctdata[0].Event_Type__c));
    }
    
    
    @future (callout=true)
    public static void calloutToGetcontractData(String evntContrctnumber,String EntityType,String EventDescription,String eventType){
        
        String requesturl = '';
        String responsebdy = '';
        
        try{
            
            List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycus = new List<GetContractDetailsWrapper.cls_metaDataField>();
            List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycusContrctHeaders = new List<GetContractDetailsWrapper.cls_metaDataField>();

            List<GetContractDetailsWrapper.cls_attachment> metadataAttachmentList = new List<GetContractDetailsWrapper.cls_attachment>();

            
            Http http 							= new Http();
            HttpRequest request 				= new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://rmicontract-jwb.zycus.com/iContract/endpoint/api/contract/'+evntContrctnumber);
            request.setHeader('x-zycus-tenantId', '4ff0449c-984c-49b5-9c9a-c6d7c0942ca9');
            request.setHeader('x-zycus-integrationTrackingNumber', '22');
            request.setTimeout(60000);
            HttpResponse response               = http.send(request);
            requesturl = request.getEndpoint();
            responsebdy = response.getBody();
            GetContractDetailsWrapper resp 	    = GetContractDetailsWrapper.parse(response.getBody());
            
            metaDatafieldDetailsFromZycus       = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractDetails.metaDataFields.metaDataField;
            
            metadataAttachmentList = resp.IntegrationEntities.integrationEntity[0].integrationEntityHeader.attachments.attachment;

            
            Map<String,String> headerValues = new Map<String,String>();
            headerValues = resp.IntegrationEntities.integrationEntity[0].integrationEntityDetails.contract.contractHeaders;
            metaDatafieldDetailsFromZycusContrctHeaders = createcontractHeaders(headerValues);
            
            metaDatafieldDetailsFromZycus.addall(metaDatafieldDetailsFromZycusContrctHeaders);
            //if(response.getStatusCode()>=200 && response.getStatusCode()<=204){
            updatecontractfrmpltEvnt(metaDatafieldDetailsFromZycus,evntContrctnumber,EntityType,EventDescription,eventType,requesturl,responsebdy,metadataAttachmentList);   
            //}else{
            //    insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Failure');
            //}
            
        }Catch(Exception e){
            HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'getcontractpltfrmEvnt', e);
            insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Failure',requesturl,responsebdy);
            updatefailurestatusincontractObj(evntContrctnumber,responsebdy);
        }
    }
    
    public static void updatecontractfrmpltEvnt(List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycus,String evntContrctnumber,String EntityType,String EventDescription,String eventType,String requestUrl, String responseBdy,List<GetContractDetailsWrapper.cls_attachment> metadataAttachmentList){
        List<Contract> erroeUpdateContrctList        = new List<Contract>();
        try{
            
            List<Contract> contrctList                                 = [Select id,Contract_Number__c,Type__c,SubType__c from Contract where Contract_Number__c=:evntContrctnumber];
            
            Map<String,String> contractIdWithZycusContrctNo            = new Map<String,String>();
            Set<String> geticontrctFieldsData                          = new Set<String>();
            Map<String,String> contrctNumWithTypeAndSubType            = new Map<String,String>();
            
            for(Contract contrc : contrctList){
                contractIdWithZycusContrctNo.put(contrc.Contract_Number__c,contrc.Id);
                geticontrctFieldsData.add(contrc.Type__c+'-'+contrc.SubType__c);
                contrctNumWithTypeAndSubType.put(contrc.Contract_Number__c,contrc.Type__c+'-'+contrc.SubType__c);
            }
            
            List<Mapping_Configurations__c> mappingConfig                     = [Select id,Type_Subtype__c,(Select id,Mapping_Configurations__r.Type_Subtype__c,Display_Name__c,DataType__c,Field_Name__c,Mapping_Field__c,Mapping_Object__c,SOT__c from IContract_Fields_Metadata__r where SOT__c=:'iContract') from Mapping_Configurations__c where Type_Subtype__c=:geticontrctFieldsData];
            
            Map<String,List<String>> icontractfieldsWithTypeAndSubtype        = new Map<String,List<String>>();
            Map<String,Map<String,String>> typeSubtypeIcontAndSfdcContrcFld   = new Map<String,Map<String,String>>();
            Map<String,Map<String,String>> iContrctFielNameAndDatatype        = new Map<String,Map<String,String>>(); 
            Map<String,List<String>> icontPicklistFieldsBasedOnTypAndSbType   = new Map<String,List<String>>();
            Set<String> icontrctPicklistListids                               = new Set<String>();
            
            for(Mapping_Configurations__c mpcng: mappingConfig){
                for(IContract_MetaData__c	 iconMtd :mpcng.IContract_Fields_Metadata__r){
                    if(!icontractfieldsWithTypeAndSubtype.containsKey(iconMtd.Mapping_Configurations__r.Type_Subtype__c)){
                        icontractfieldsWithTypeAndSubtype.put(iconMtd.Mapping_Configurations__r.Type_Subtype__c,new List<String>{iconMtd.Field_Name__c});
                        typeSubtypeIcontAndSfdcContrcFld.put(iconMtd.Mapping_Configurations__r.Type_Subtype__c,new Map<string,String>{iconMtd.Field_Name__c=>iconMtd.Mapping_Field__c});
                        iContrctFielNameAndDatatype.put(iconMtd.Mapping_Configurations__r.Type_Subtype__c,new Map<string,String>{iconMtd.Field_Name__c=>iconMtd.DataType__c});
                    }else{
                        icontractfieldsWithTypeAndSubtype.get(iconMtd.Mapping_Configurations__r.Type_Subtype__c).add(iconMtd.Field_Name__c);
                        typeSubtypeIcontAndSfdcContrcFld.get(iconMtd.Mapping_Configurations__r.Type_Subtype__c).put(iconMtd.Field_Name__c,iconMtd.Mapping_Field__c);
                        iContrctFielNameAndDatatype.get(iconMtd.Mapping_Configurations__r.Type_Subtype__c).put(iconMtd.Field_Name__c,iconMtd.DataType__c);
                    }
                    
                    
                    String objectName = 'Contract';
                    String contrctFieldName = String.valueOf(iconMtd.Mapping_Field__c).toLowercase();
                    SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    String datatype = String.valueOf(d.fields.getMap().get(contrctFieldName).getDescribe().getType()).toLowercase();
                    
                    if(datatype == 'picklist' ||datatype == 'multipicklist'){    
                        if(!icontPicklistFieldsBasedOnTypAndSbType.containsKey(iconMtd.Mapping_Configurations__r.Type_Subtype__c)){
                            icontPicklistFieldsBasedOnTypAndSbType.put(iconMtd.Mapping_Configurations__r.Type_Subtype__c,new List<String>{iconMtd.Field_Name__c});
                        }else{
                            icontPicklistFieldsBasedOnTypAndSbType.get(iconMtd.Mapping_Configurations__r.Type_Subtype__c).add(iconMtd.Field_Name__c); 
                        }
                        icontrctPicklistListids.add(iconMtd.id);
                    }
                    
                }
            }
            
            
            List<IContract_MetaData__c> iconMetadataforPicklist        = [Select id,Mapping_Configurations__r.Type_Subtype__c,Field_Name__c,(Select id,IContract_Value__c,Mapping_Field__c,Mapping_Value__c from Value_Mappings__r) from IContract_MetaData__c where id=:icontrctPicklistListids];
            
            Map<String,Map<String,String>> typesubtypeFieldPicklistVal = new Map<String,Map<String,String>>();
            Map<String,Set<String>> picklistValMappedChecker           = new Map<String,Set<String>>();
            
            for(IContract_MetaData__c iconmtd : iconMetadataforPicklist){
                for(Value_Mapping__c vmp : iconmtd.Value_Mappings__r){
                    if(!typesubtypeFieldPicklistVal.containsKey(iconmtd.Mapping_Configurations__r.Type_Subtype__c+'@@@'+iconmtd.Field_Name__c)){
                        typesubtypeFieldPicklistVal.put(iconmtd.Mapping_Configurations__r.Type_Subtype__c+'@@@'+iconmtd.Field_Name__c,new Map<string,String>{vmp.IContract_Value__c=>vmp.Mapping_Value__c});
                        picklistValMappedChecker.put(iconmtd.Mapping_Configurations__r.Type_Subtype__c+'@@@'+iconmtd.Field_Name__c,new set<String>{vmp.IContract_Value__c});
                    }else{
                        typesubtypeFieldPicklistVal.get(iconmtd.Mapping_Configurations__r.Type_Subtype__c+'@@@'+iconmtd.Field_Name__c).put(vmp.IContract_Value__c,vmp.Mapping_Value__c);    
                        picklistValMappedChecker.get(iconmtd.Mapping_Configurations__r.Type_Subtype__c+'@@@'+iconmtd.Field_Name__c).add(vmp.IContract_Value__c);
                    }
                }
            }
            
            List<Contract> updateContrctList        = new List<Contract>();//update this and test
            Map<String,String> contractIdwithItsNumberKey = new Map<String,String>();
            
            for(Contract contrc : contrctList){
                Contract errorupdateContractRecord       = new Contract();
                Contract updateContractRecord       = new Contract();
                
                updateContractRecord.put('Id',contrc.Id);
                
                for(GetContractDetailsWrapper.cls_metaDataField metadataval: metaDatafieldDetailsFromZycus){
                    
                    if(icontractfieldsWithTypeAndSubtype.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).contains(metadataval.fieldName)){
                        
                        String objectName = 'Contract';
                        String contrctFieldName = typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName).toLowercase();
                        SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        String datatype = String.valueOf(d.fields.getMap().get(contrctFieldName).getDescribe().getType()).toLowercase();
                        
                        
                        if(datatype == 'currency' || datatype == 'double' || datatype == 'percent' || datatype == 'decimal'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),decimal.valueOf(metadataval.fieldValue));
                            }
                        }
                        else if(datatype == 'integer'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),integer.valueOf(metadataval.fieldValue));
                            }
                        }
                        else if(datatype=='boolean'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                
                                if(metadataval.fieldValue=='YES'||metadataval.fieldValue=='yes'){
                                    metadataval.fieldValue = 'true';
                                }else if(metadataval.fieldValue=='NO'||metadataval.fieldValue=='no'){
                                    metadataval.fieldValue = 'false';
                                }
                                
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),boolean.valueOf(metadataval.fieldValue));
                            }  
                        }
                        else if(datatype=='date'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),date.valueOf(metadataval.fieldValue));
                            }     
                        }
                        else if(datatype=='multipicklist'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                List<String> Multipicklistvalsetup = String.valueOf(metadataval.fieldValue).split(';');
                                String prepareval = '';
                                for(integer i=1;i<=Multipicklistvalsetup.size();i++){
                                    if(picklistValMappedChecker.containskey(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName)){                                                                                                      
                                        if(picklistValMappedChecker.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName).contains(String.valueOf(Multipicklistvalsetup[i-1]))){
                                            
                                            if(i==Multipicklistvalsetup.size()){
                                                prepareval = prepareval + typesubtypeFieldPicklistVal.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName).get(String.valueOf(Multipicklistvalsetup[i-1]));
                                            }else{
                                                prepareval = prepareval + typesubtypeFieldPicklistVal.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName).get(String.valueOf(Multipicklistvalsetup[i-1]))+';';
                                            }
                                        }
                                    }
                                }
                                
                                if(prepareval!='')
                                    updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),prepareval);
                            } 
                            
                        }
                        else if(datatype=='datetime'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),Datetime.valueOf(metadataval.fieldName));//
                                
                                // insertcontractRecd.put(dataCrtcontr.FieldApiName,Datetime.valueOf(dataCrtcontr.FieldValue.split('\\.')[0].replace('T',' ')));
                            } 
                        }
                        else if(datatype=='picklist'){
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                if(picklistValMappedChecker.containskey(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName)){                                                                                                      
                                    if(picklistValMappedChecker.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName).contains(String.valueOf(metadataval.fieldValue))){
                                        updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),typesubtypeFieldPicklistVal.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)+'@@@'+metadataval.fieldName).get(String.valueOf(metadataval.fieldValue)));
                                        
                                    } 
                                }
                            }
                        }
                        else{
                            // for string,text,teaxtarea,textarearich,textarealong,url,email,phone
                            if(!(metadataval.fieldValue == '' || metadataval.fieldValue == null || metadataval.fieldValue == 'null')){
                                updateContractRecord.put(typeSubtypeIcontAndSfdcContrcFld.get(contrctNumWithTypeAndSubType.get(contrc.Contract_Number__c)).get(metadataval.fieldName),String.valueOf(metadataval.fieldValue));
                            }
                        }
                        
                    }
                }//system.debug(updateContractRecord);
                updateContractRecord.put('Last_update_from_Icontarct__c',system.now());
                updateContrctList.add(updateContractRecord);
                erroeUpdateContrctList.add(new contract(id=contrc.id,Icontract_update_message__c=responseBdy));
                contractIdwithItsNumberKey.put(contrc.Contract_Number__c,contrc.id);
            }
            
            if(!updateContrctList.isEmpty()){
                
                update updateContrctList;
                
                insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Success',requesturl,responseBdy);
                
            }
            
            if(!metadataAttachmentList.isEmpty()){
              createReferenceDocData(metadataAttachmentList,evntContrctnumber,contractIdwithItsNumberKey);
             }
            
            system.debug('updateContrctList'+updateContrctList);
        }Catch(Exception e){
            HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'updatecontractfrmpltEvnt', e);
            insertPayloadData(evntContrctnumber,EntityType,EventDescription,eventType,'Failure',requesturl,responseBdy);
            try{
                if(!erroeUpdateContrctList.isEmpty())
                    update erroeUpdateContrctList;
            }Catch(Exception ex){
                HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'updatecontractfrmpltEvnt-innercatch', ex);    
            }
        }
    }
    
    
    public static void createReferenceDocData(List<GetContractDetailsWrapper.cls_attachment> metadataAttachmentList,String evntContrctnumber,Map<string,String> contractIdwithItsNumberKey){
       
      List<Reference_Documents__c> refDocList = new List<Reference_Documents__c>();  
        for(GetContractDetailsWrapper.cls_attachment attchmnt: metadataAttachmentList){
			Reference_Documents__c refdoc =  new Reference_Documents__c();
            refdoc.File_Name__c = attchmnt.Name;
            refdoc.Zycus_File_Id__c = attchmnt.id;
            refdoc.File_size__c = attchmnt.size;
            refdoc.ExternalID__c = attchmnt.id+attchmnt.Name+evntContrctnumber;
            refdoc.Contract__c = contractIdwithItsNumberKey.get(evntContrctnumber);
            refDocList.add(refdoc);
        }
       if(refDocList.size()>0)
           upsert refDocList ExternalID__c;
        
        //now do a callout to get its body details
        
    }
    
    public static void insertPayloadData(String evntContrctnumber,String EntityType,String EventDescription,String eventType,String status,String requestUrl,String responseBdy){
        try{
            List<PayLoad__c> payload = [Select id,CalloutCount__c from PayLoad__c where Contract_Number__c=:evntContrctnumber and Function_Type__c =:Constants.FUNCTION_TYPE_GET_CONTRACT_PE LIMIT 1];
            PayLoad__c payloadData = new PayLoad__c();
            payloadData.Function_Type__c = Constants.FUNCTION_TYPE_GET_CONTRACT_PE;
            payloadData.API_Request__c = requestUrl;
            payloadData.API_Response__c = responseBdy; 
            payloadData.Contract_Number__c=evntContrctnumber;
            payloadData.Entity_Type__c=EntityType;
            payloadData.Event_Description__c=EventDescription;
            payloadData.Event_Type__c=eventType;
            payloadData.Status__c = status;
            if(payload.size()>0){
                payloadData.CalloutCount__c = payload[0].CalloutCount__c + 1;
                payloadData.id = payload[0].id;
            }else{
                payloadData.CalloutCount__c=1;
            }
            system.debug(payloadData);
            upsert payloadData;
        }Catch(Exception e){
            HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'insertPayloadData', e);
        }
    }
    
    public static List<GetContractDetailsWrapper.cls_metaDataField> createcontractHeaders(Map<String,String> headerValDetails){
        
        List<Create_Contract_API_Mapping__mdt> getcontrctMetadataList =  CreateContractCtrlModel.getContractMappingCMList();
        
        Map<String,String> headerkeyAPINameVal = new Map<String,String>(); 
        for(Create_Contract_API_Mapping__mdt getcontrctmtd : getcontrctMetadataList){
            if(getcontrctmtd.Type__c == 'Contract Headers' && getcontrctmtd.Mapping_Contract_Field__c != null && getcontrctmtd.Mapping_Contract_Field__c != '' && getcontrctmtd.Mapping_Contract_Field__c != ' '){
                headerkeyAPINameVal.put(getcontrctmtd.MasterLabel,getcontrctmtd.Mapping_Contract_Field__c);   
            }
        }
        
        List<GetContractDetailsWrapper.cls_metaDataField> metaDatafieldDetailsFromZycus = new List<GetContractDetailsWrapper.cls_metaDataField>();
        
        for(String s :headerValDetails.keyset()){
            if(headerValDetails.get(s)!='' && headerValDetails.get(s)!=null && headerValDetails.get(s)!='null' && headerkeyAPINameVal.containsKey(s)){
                GetContractDetailsWrapper.cls_metaDataField statusvalfromContrctHeader = new GetContractDetailsWrapper.cls_metaDataField();
                statusvalfromContrctHeader.fieldName = headerkeyAPINameVal.get(s);
                statusvalfromContrctHeader.fieldValue = headerValDetails.get(s);
                metaDatafieldDetailsFromZycus.add(statusvalfromContrctHeader);
                //system.debug(s);
                //system.debug(headerValDetails.get(s));
            }
        }
        return metaDatafieldDetailsFromZycus;
    }
    
    public static void updatefailurestatusincontractObj(String contrctnumber,String response){
        try{
        contract contrct = [Select id from contract where Contract_Number__c=:contrctnumber Limit 1];
        contrct.Icontract_update_message__c = response;
        update contrct;
        }Catch(Exception e){
            HandleBusinessException.captureError('IcontractGetContractPltfrmEvntHelper', 'updatefailurestatusincontractObj', e);
        }
    }
}