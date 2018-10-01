/*----------------------------------------------------------------------------
 * Description :   This classed is used basic authentication callout.
 * Created By  :   Siva Krishna Reddy B
 * Created Date:   21/05/2018
 * Version     :   V1.0
 ---------------------------------------------------------------------------*/
public class BasicAuthenticationClass {
	
	public static string basicAuthentictionCallout(string methodName, String endPointUrl,String nonce){
    	//get access data custom settings
    	Basic_Authentication__c ba = Basic_Authentication__c.getOrgDefaults();
    
    	//signature generation 
    	String base64key = EncodingUtil.base64Encode(blob.valueOf(ba.Username__c+':'+ba.Password__c));
		String sign1=  methodName + '\n' + endPointUrl + '\n' + 'x-zycus-applicationid:'+ba.Application_Id__c+'\n'+'x-zycus-nonce:'+nonce+'\n'+'x-zycus-username:'+ba.Username__c+'';
		Blob data = crypto.generateMac('HmacSHA256',Blob.valueOf(sign1), blob.valueOf(base64key));
		string signature  = EncodingUtil.convertToHex(data);
		System.debug('........123'+signature);
    	return signature;  
    }    
}