/***********************************************************************************************
Author : Siva Krishna Reddy B
Purpose : This class is used to define unit test for SecurityUtils Controller.
Created Date : 01/06/2018
Lastmodified By : 
Reason: 
*****************************************************************************************************/
@isTest
public class SecurityUtilsTest {
    
	   static User setupTestUser(String profileName){
		//username global uniqueness is still enforced in tests 
		//make sure we get something unique to avoid issues with parallel tests
		String uniqueness = DateTime.now()+':'+Math.random();
		try{ 
			throw new NullPointerException();
		}catch(Exception e){
			uniqueness += e.getStackTraceString(); //includes the top level test method name without having to pass it
		}
		Profile p = [SELECT id, Name FROM Profile WHERE Name = :profileName];
		User result = new User(
			username=UserInfo.getUserId()+'.'+uniqueness.HashCode()+'@'+UserInfo.getOrganizationId()+'.sfdcOrg',
			alias = 'testExec',
			email='apextests@example.com',
			emailencodingkey='UTF-8',
			lastname='Testing',
			languagelocalekey='en_US',
			localesidkey='en_US',
			profileid = p.Id,
			timezonesidkey='America/Los_Angeles'
		);
		insert result;
		return result;
	}

	@isTest
	static void readonly_field_access() {
		User testUser = setupTestUser('Read Only');
		System.runAs(testUser){
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkFieldIsInsertable(Account.SObjectType, 'naMe');
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
                system.debug(ex);
				System.assertNotEquals(null,ex, 'Read only profile should not be able to insert Account.Name');
				System.assert(ex instanceof SecurityUtils.FlsException, 'Expected an FlsException, got '+ex.getTypeName());
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertEquals(null, ex, 'Read only profile should be able to read Contact.LastName');
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkFieldIsUpdateable(Lead.SObjectType, 'cOMPANY');
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead.Company');
				System.assert(ex instanceof SecurityUtils.FlsException, 'Expected an FlsException, got '+ex.getTypeName());
			}

			SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
			{ //no exceptions, despite no rights
				SecurityUtils.checkFieldIsInsertable(Account.SObjectType, 'naMe');
				SecurityUtils.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
				SecurityUtils.checkFieldIsUpdateable(Lead.SObjectType, 'cOMPANY');
			}
		}
	}

	@isTest
	static void readonly_object_access() {
		User testUser = setupTestUser('Read Only');
		System.runAs(testUser){
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkObjectIsInsertable(Account.SObjectType);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to insert Account');
				System.assert(ex instanceof SecurityUtils.CrudException, 'Expected an CrudException, got '+ex.getTypeName());
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkObjectIsReadable(Contact.SObjectType);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertEquals(null, ex, 'Read only profile should be able to read Contact');
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkObjectIsUpdateable(Lead.SObjectType);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead');
				System.assert(ex instanceof SecurityUtils.CrudException, 'Expected an CrudException, got '+ex.getTypeName());
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkObjectIsDeletable(Opportunity.SObjectType);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to delete Opportunity');
				System.assert(ex instanceof SecurityUtils.CrudException, 'Expected an CrudException, got '+ex.getTypeName());
			}

			SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
			{ //no exceptions, despite no rights
				SecurityUtils.checkObjectIsInsertable(Account.SObjectType);
				SecurityUtils.checkObjectIsReadable(Contact.SObjectType);
				SecurityUtils.checkObjectIsUpdateable(Lead.SObjectType);
				SecurityUtils.checkObjectIsDeletable(Opportunity.SObjectType);
			}
		}
	}

	@isTest
	static void readonly_objectAndField_access() {
		User testUser = setupTestUser('Read Only');
		System.runAs(testUser){
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkInsert(
						Account.SObjectType,
						new List<String>{
							'Name',
							'ParentId',
							'ownerId'
						}
					);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to insert Account');
				System.assert(ex instanceof SecurityUtils.CrudException, 'Expected an CrudException, got '+ex.getTypeName());
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkRead(
						Contact.SObjectType,
						new List<String>{
							'LastName',
							'accountId',
							'ownerId'
						}
					);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertEquals(null, ex, 'Read only profile should be able to read Contact');
			}
			{
				SecurityUtils.SecurityException ex;
				try{
                    SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = false;
					SecurityUtils.checkUpdate(
						Lead.SObjectType,
						new List<String>{
							'LastName',
							'FirstNAMe',
							'cOMPANY'
						}
					);
				}catch(SecurityUtils.SecurityException e){
					ex = e;
				}
				System.assertNotEquals(null, ex, 'Read only profile should not be able to update Lead');
				System.assert(ex instanceof SecurityUtils.CrudException, 'Expected an CrudException, got '+ex.getTypeName());
			}

			SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
			{ //no exceptions, despite no rights
				SecurityUtils.checkInsert(
					Account.SObjectType,
					new List<String>{
						'Name',
						'Type',
						'ownerId'
					}
				);
				SecurityUtils.checkRead(
					Contact.SObjectType,
					new List<String>{
						'LastName',
						'accountId',
						'ownerId'
					}
				);
				SecurityUtils.checkUpdate(
					Lead.SObjectType,
					new List<String>{
						'LastName',
						'FirstNAMe',
						'cOMPANY'
					}
				);
			}
		}
	}

	@isTest
	static void sysadmin_objectAndField_access() {
		User testUser = setupTestUser('System Administrator');
		System.runAs(testUser){
			SecurityUtils.checkInsert(
				Account.SObjectType,
				new List<Schema.SObjectField>{
					Account.SObjectType.fields.Name,
					Account.SObjectType.fields.ParentId,
					Account.SObjectType.fields.ownerId
				}
			);
			SecurityUtils.checkRead(
				Contact.SObjectType,
				new List<Schema.SObjectField>{
					Contact.SObjectType.fields.LastName,
					Contact.SObjectType.fields.accountId,
					Contact.SObjectType.fields.ownerId
				}
			);
			SecurityUtils.checkUpdate(
				Lead.SObjectType,
				new List<Schema.SObjectField>{
					Lead.SObjectType.fields.LastName,
					Lead.SObjectType.fields.FirstNAMe,
					Lead.SObjectType.fields.cOMPANY
				}
			);
		}
	}	
}