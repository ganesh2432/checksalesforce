/*----------------------------------------------------------------------------
 * Description :   This controller to query data from DB.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   19/08/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public with sharing class ContractPartyCreationAPIModel {
	
    //Method to query account and contact data
    public static Map<Account, List<Contact>> getAccountContactList(String AccountId){
        Map<Account,List<Contact>> accountContactMap = new Map<Account,List<Contact>>();
        //Query Account and contact data
        List<Account> accountList = [select id,Name, (select id,firstName,lastName,email,phone from Contacts) from Account where id=:AccountId];       
        for(Account account:accountList){
            List<contact> conlist = account.Contacts;
            accountContactMap.put(account,conlist);           
        }
        return accountContactMap;
    }
}