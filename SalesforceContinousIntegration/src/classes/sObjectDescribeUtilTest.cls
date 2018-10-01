/***********************************************************************************************
Author : Siva Krishna Reddy B
Purpose : This class is used to define unit test for sObjectDescribeUtil.
Created Date : 01/06/2018
Lastmodified By : 
Reason: 
*****************************************************************************************************/
@isTest
public class sObjectDescribeUtilTest {

	/**
	 * Verify that the different ways of getting your hands on an SObjectDescribe instance all handle null inputs
	 * by returning null - since there's no possible way to resolve it.
	**/
	@isTest
	static void getDescribe_badInput(){
		String nullStr = null; //having it as a string var makes for unambiguous selection of overloads
		Schema.SObjectType nullType = null;
		Schema.DescribeSObjectResult nullDescribe = null;
		SObject nullSObject = null;
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(nullStr));
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(''));
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(' '));
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(nullType));
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(nullDescribe));
		System.assertEquals(null, SObjectDescribeUtil.getDescribe(nullSObject));
	}

	@isTest
	static void NamespacedAttributeMap_implementations(){
		SObjectDescribeUtil.GlobalDescribeMap gdm = SObjectDescribeUtil.getGlobalDescribe();
		Schema.SObjectType accountObjType = gdm.get('AccOunT');
		System.assertEquals(accountObjType, Account.SobjectType);
		System.assertEquals(Schema.getGlobalDescribe().size(), gdm.size());

		SObjectDescribeUtil acccountDescribe = SObjectDescribeUtil.getDescribe(accountObjType);
		SObjectDescribeUtil.FieldsMap fields = acccountDescribe.getFields();
		System.assert( fields.keySet().containsAll(acccountDescribe.getFieldsMap().keySet()) );

		System.assertEquals(fields.get('name'), Account.SObjectType.fields.name); //behavior of FieldsMap is tested in another method
		System.assertEquals(Schema.SObjectType.Account.fields.getMap().size(), fields.size());

		System.assertEquals(null, fields.get(null), 'Null input should result in null ouput.');
		System.assertEquals(null, fields.get(''), 'Invalid fieldname input should result in null ouput.');
	}

	@isTest
	static void FieldsMap(){
		String fakeNamespace = 'zycus_test';
		Map<String,Schema.SObjectField> fakeFieldData = new Map<String,Schema.SObjectField>{
			'name__c' => Contact.SObjectType.fields.name, //re-use standard field types since we can't mock them
			fakeNamespace+'__name__c' => Account.SObjectType.fields.name,
			fakeNamespace+'__otherField__c' => Account.SObjectType.fields.name,
			'createddate' => Contact.SObjectType.fields.CreatedDate
		};
		SObjectDescribeUtil.FieldsMap fields = new SObjectDescribeUtil.FieldsMap(fakeFieldData);
		fields.currentNamespace = fakeNamespace;
		System.assertEquals(true, fields.containsKey('name__c') );
		System.assertEquals(true, fields.containsKey(fakeNamespace.toUpperCase()+'__nAMe__c') );
		System.assert(fields.get('NAme__c') === fields.get(fakeNamespace+'__namE__c'));

		System.assert(!fields.keySet(false).contains('otherField__c'));
		System.assert(fields.keySet(false).contains(fakeNamespace+'__otherField__c'));

		System.assert(fields.keySet(true).contains('otherField__c'));
		System.assert(!fields.keySet(true).contains(fakeNamespace+'__otherField__c'));

		fields.currentNamespace = 'someOtherNamespace';
		System.assertNotEquals(fields.get('name__C'), fields.get(fakeNamespace.capitalize()+'__nAme__c'));
	}

	@isTest
	static void GlobalDescribeMap(){
		String fakeNamespace = 'zycus_test';
		Map<String,Schema.SObjectType> fakeFieldData = new Map<String,Schema.SObjectType>{
			'name__c' => Contact.SObjectType, //re-use stndard object types since we can't mock them
			fakeNamespace+'__name__c' => Account.SObjectType,
			'createddate' => Lead.SObjectType
		};
		SObjectDescribeUtil.GlobalDescribeMap gdm = new SObjectDescribeUtil.GlobalDescribeMap(fakeFieldData);
		gdm.currentNamespace = fakeNamespace;        
		System.assertEquals(true, gdm.containsKey('name__c') );
		System.assertEquals(true, gdm.containsKey(fakeNamespace+'__name__c') );
		System.assert(gdm.get('name__c') === gdm.get(fakeNamespace+'__name__c'));
		gdm.currentNamespace = 'someOtherNamespace';
		System.assertNotEquals(gdm.get('name__c'), gdm.get(fakeNamespace+'__name__c'));
	}

	@isTest //Tests all forms of the getDescribe static
	static void getAccountDescribes(){
		SObjectDescribeUtil d = SObjectDescribeUtil.getDescribe('Account');
		SObjectDescribeUtil d2 = SObjectDescribeUtil.getDescribe(Account.SObjectType);
		SObjectDescribeUtil d3 = SObjectDescribeUtil.getDescribe(Schema.SObjectType.Account);
		System.assertEquals('Account', d.getDescribe().getName());
		System.assert( (d === d2 && d2 === d3) ,'All three getDescribe calls should return the same cached instance.');
	}

	@isTest
	static void simpleAccountFieldDescribe(){
		SObjectDescribeUtil d = SObjectDescribeUtil.getDescribe(Account.SObjectType);
		Map<String,Schema.SObjectField> fields;
		for(integer i = 0; i < 10; i++){
			fields = d.getFieldsMap();
		}

        
		// System.assertEquals(1, Limits.getFieldsDescribes() );

		System.assertEquals(false,fields.isEmpty());
		System.assertEquals(Account.SObjectType, d.getSObjectType());
	}

	@isTest
	static void simpleAccountFieldSetDescribe(){
		SObjectDescribeUtil d = SObjectDescribeUtil.getDescribe(Account.SObjectType);
		Map<String,Schema.FieldSet> fields;
		for(integer i = 0; i < 10; i++){
			fields = d.getFieldSetsMap();
		}

		// System.assertEquals(1, Limits.getFieldSetsDescribes() );

		// no asserts on result size to avoid a requirement on field sets existing
	}

	@isTest
    	static void simpleAccountGetNameField(){
        	SObjectDescribeUtil d = SObjectDescribeUtil.getDescribe(Account.SObjectType);
        	Schema.SObjectField nameField = d.getNameField();
        	System.assertEquals('Name', nameField.getDescribe().getName());
	}

	@isTest
	static void flushCache(){
		SObjectDescribeUtil d = SObjectDescribeUtil.getDescribe('Account');
		SObjectDescribeUtil.flushCache();
		SObjectDescribeUtil d2 = SObjectDescribeUtil.getDescribe('Account');
		System.assert(d !== d2, 'Second object should be a fresh instance after a cache flush.' );
	}

	@isTest
	static void rawGlobalDescribeCheck(){
		Map<String,Schema.SObjectType> systemGd = Schema.getGlobalDescribe();
		Map<String,Schema.SObjectType> cachedGd = SObjectDescribeUtil.getRawGlobalDescribe();
		System.assertEquals(systemGd.size(),cachedGd.size());
	}


}