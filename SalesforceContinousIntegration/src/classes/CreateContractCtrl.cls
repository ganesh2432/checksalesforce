public class CreateContractCtrl {

    
    public static String createReqJSON(String cId, Contract contractSObj){
        Contract cObj 	= new Contract();
	//	query 			= query.replace(',Name,',',');
        if(String.isBlank(cId)) cObj	= contractSObj;
        else{
            String query 	= Utility.getDynamQuery('Contract', 'Id =: cId');  
            cObj 			= Database.query(query);   
        }
        CreateContractWrapper.cls_attachments attachment 	= new CreateContractWrapper.cls_attachments();
        CreateContractWrapper.cls_integrationEntityHeader integrationHeader 	= new CreateContractWrapper.cls_integrationEntityHeader();
        integrationHeader.integrationTrackingNumber = 'INTEGRATIONTRACKINGNUMBER';
        integrationHeader.referenceCodeForEntity = '';
        attachment.attachment 	= new List<CreateContractWrapper.cls_attachment>();
        integrationHeader.attachments = attachment;
        
/*        List<CreateContractWrapper.cls_metaDataField> metaDataField 	= new List<CreateContractWrapper.cls_metaDataField>();
        CreateContractWrapper.cls_metaDataField metadataFieldObj 		= new CreateContractWrapper.cls_metaDataField();
        metadataFieldObj.fieldName 										= 'Terms';
        metadataFieldObj.fieldValue 									= 'Active';
        metaDataField.add(metadataFieldObj);
        
        CreateContractWrapper.cls_metaDataFields metadataFields 		= new CreateContractWrapper.cls_metaDataFields();
        metadataFields.metaDataField									= metaDataField;
        
        List<CreateContractWrapper.cls_customField> entityCustomFields 	= new List<CreateContractWrapper.cls_customField>();
        CreateContractWrapper.cls_customField entityCustomField1 		= new CreateContractWrapper.cls_customField();
        CreateContractWrapper.cls_customField entityCustomField2 		= new CreateContractWrapper.cls_customField();
        entityCustomField1.fieldName									= 'Financial_Obligations';
        entityCustomField2.fieldName									= 'Obligatory_to';
        entityCustomField1.fieldValue									= '123';
        entityCustomField2.fieldValue									= '';
        entityCustomFields.add(entityCustomField1);
        entityCustomFields.add(entityCustomField2);
        
        CreateContractWrapper.cls_customFields customField 				= new CreateContractWrapper.cls_customFields();
        customField.customField 										= entityCustomFields;
        
        CreateContractWrapper.cls_customEntity custEntity 				= new CreateContractWrapper.cls_customEntity();
        custEntity.customFields 										= customField;
        
        CreateContractWrapper.cls_customEntityWrapper custEntityWrap 	= new CreateContractWrapper.cls_customEntityWrapper();
        custEntityWrap.customEntity 									= new List<CreateContractWrapper.cls_customEntity>{custEntity};
            
        CreateContractWrapper.cls_customEntityList custEntityList 		= new CreateContractWrapper.cls_customEntityList();
        custEntityList.customEntityName 								= 'FinancialObligations';
        custEntityList.customEntityWrapper 								= custEntityWrap;
        
        CreateContractWrapper.cls_customEntities custEntities 			= new CreateContractWrapper.cls_customEntities();
        custEntities.customEntityList 									= new List<CreateContractWrapper.cls_customEntityList>{custEntityList};
                        
        CreateContractWrapper.cls_contractDetails contDetails 			= new CreateContractWrapper.cls_contractDetails();
        contDetails.metaDataFields										= metadataFields;
        contDetails.customEntities 										= custEntities;*/
        
        CreateContractWrapper.cls_amendmentDetails amendDetails 		= new CreateContractWrapper.cls_amendmentDetails();
//        amendDetails.amendmentNo 										= '123';
//        amendDetails.amendmentEffectiveDate 							= '2020-05-31';    
/*        
        CreateContractWrapper.cls_primaryContractingParty pContractPar 	= new CreateContractWrapper.cls_primaryContractingParty();
        pContractPar.primaryContractingPartyId 							= '842708';
        pContractPar.primaryContractingPartyName 						= '';    
        pContractPar.contactPersonId 									= '';    
        
        CreateContractWrapper.cls_otherContractingParties oContractPar 	= new CreateContractWrapper.cls_otherContractingParties();
        oContractPar.otherContractingParty 								= new List<CreateContractWrapper.cls_otherContractingParty>();
*/
     /*   CreateContractWrapper.cls_contractingParties contractPar 	= new CreateContractWrapper.cls_contractingParties();
        contractPar.primaryContractingParty							= pContractPar;
        contractPar.otherContractingParties							= oContractPar;
       */
        CreateContractWrapper.cls_amendments amends 				= new CreateContractWrapper.cls_amendments();
        amends.amendmentId 											= new List<CreateContractWrapper.cls_amendmentId>();
     /*    
        CreateContractWrapper.cls_poInformation poInform 			= new CreateContractWrapper.cls_poInformation();
        poInform.poQuantity 										= '';
        poInform.poNumber 											= 'P734';
        poInform.poDate 											= '2017-08-01';
        poInform.poUnitPrice 										= '55673';
        poInform.vendorId 											= '9234';
        poInform.poDescription 										= '';
        
        CreateContractWrapper.cls_poDetails poDetails 				= new CreateContractWrapper.cls_poDetails();
        poDetails.poInformation 									= new List<CreateContractWrapper.cls_poInformation>{poInform};
        */
        CreateContractWrapper.cls_utilization utilization 			= new CreateContractWrapper.cls_utilization();
   /*     utilization.utilizationAmount 								= '400';
        utilization.percentUtilization 								= '7';
        utilization.poDetails 										= poDetails;
     */       
        CreateContractWrapper.cls_contract contractObj 	= new CreateContractWrapper.cls_contract();
/*        Map<String, String> standardField 				= new Map<String, String>();
        standardField.put('type', 'Underwriting');
        standardField.put('subType', 'Work Order');
        standardField.put('status', 'Active');
        standardField.put('contractNumber', '');
        standardField.put('contractTitle', 'Contract without audits 4');
        standardField.put('contractOwner', 'adesh.dsilva@zycus.com');
        standardField.put('hierarchyStatus', 'standalone');
        standardField.put('folder', 'default');
        contractObj.contractHeaders 	= standardField;
        contractObj.contractId			= '4028861d60c0c23e0160d491f9040071';
        contractObj.externalId			= 'ICONTRACT_SYSTEM_TEST_EXTERNAL_ID';
        contractObj.isAmendment			= 'No'; */
//        contractObj.contractDetails 	= contDetails;
        contractObj.amendmentDetails 	= amendDetails;
  //      contractObj.contractingParties  = contractPar;
        contractObj.amendments  		= amends;
        contractObj.utilization  		= utilization;
        contractObj						= CreateContractCtrlService.mapFields(contractObj, cObj.Type__c, cObj.SubType__c, cObj);
        
        CreateContractWrapper.cls_integrationEntityDetails intEntityDet 	= new CreateContractWrapper.cls_integrationEntityDetails();
        intEntityDet.contract	= contractObj;
        
        CreateContractWrapper.cls_integrationEntity integrationEntity = new CreateContractWrapper.cls_integrationEntity();
        integrationEntity.integrationEntityHeader	= integrationHeader;
        integrationEntity.integrationEntityDetails	= intEntityDet;
        CreateContractWrapper.cls_IntegrationEntities integrationEntities = new CreateContractWrapper.cls_IntegrationEntities();
        integrationEntities.integrationEntity 	= new List<CreateContractWrapper.cls_integrationEntity>{integrationEntity};
        CreateContractWrapper contractWrap 		= new CreateContractWrapper();
        contractWrap.IntegrationEntities 		= integrationEntities;
        String res 								= JSON.serialize(contractWrap);
        res										= res.replace('ccurrency', 'currency');
        system.debug('res:::::'+res);
        return res;
    }
}