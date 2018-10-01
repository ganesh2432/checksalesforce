public class IconsoleIntegration {
    
        
    //Checking For  Git Commands

    static Map<String,String> base64DecodeTable=new Map<String,String>{'A'=>'000000',
    'B'=>'000001','Q'=>'010000','f'=>'011111','u'=>'101110','9'=>'111101',
    'C'=>'000010','R'=>'010001','g'=>'100000','v'=>'101111','+'=>'111110',
    'D'=>'000011','S'=>'010010','h'=>'100001','w'=>'110000','/'=>'111111',
    'E'=>'000100','T'=>'010011','i'=>'100010','x'=>'110001','='=>'000000',
    'F'=>'000101','U'=>'010100','j'=>'100011','y'=>'110010',
    'G'=>'000110','V'=>'010101','k'=>'100100','z'=>'110011',
    'H'=>'000111','W'=>'010110','l'=>'100101','0'=>'110100',
    'I'=>'001000','X'=>'010111','m'=>'100110','1'=>'110101',
    'J'=>'001001','Y'=>'011000','n'=>'100111','2'=>'110110',
    'K'=>'001010','Z'=>'011001','o'=>'101000','3'=>'110111',
    'L'=>'001011','a'=>'011010','p'=>'101001','4'=>'111000',
    'M'=>'001100','b'=>'011011','q'=>'101010','5'=>'111001',
    'N'=>'001101','c'=>'011100','r'=>'101011','6'=>'111010',
    'O'=>'001110','d'=>'011101','s'=>'101100','7'=>'111011',
    'P'=>'001111','e'=>'011110','t'=>'101101','8'=>'111100'};
    
     //map to convert eight bit binary string to decmal value
    static Map<Integer,Integer> binaryToDecimalMap=new Map<Integer,Integer>{0=>-128,1=>64,2=>32,3=>16,4=>8,5=>4,6=>2,7=>1};
    
        
    //Method to get hex equivalent of 8 bit binary data
    public static String binaryToHexString(String binaryString){
        return binaryToHexTable.get(binaryString);
    }
    static Map<String,String> binaryToHexTable=new Map<String,String>{
        '0000'=>'0',
        '0001'=>'1',
        '0010'=>'2',
        '0011'=>'3',
        '0100'=>'4',
        '0101'=>'5',
        '0110'=>'6',
        '0111'=>'7',
        '1000'=>'8',
        '1001'=>'9',
        '1010'=>'A',
        '1011'=>'B',
        '1100'=>'C',
        '1101'=>'D',
        '1110'=>'E',
        '1111'=>'F'

    };
    
     public static HttpRequest createRequest(String endpoint,String method,String body){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);   
        request.setMethod(method);
        if(method.equalsIgnoreCase('POST'))
        {
            request.setHeader('Content-Type', 'application/json; charset=UTF-8');
            request.setBody(body);
        }
        return request;
    }
    
    
     public static List<Integer> B64ToBytes (String sIn) {
        Map<Integer,Integer> base64 = new Map<Integer,Integer>{65=>0,66=>1,67=>2,68=>3,69=>4,70=>5,71=>6,72=>7,73=>8,74=>9,75=>10,76=>11,77=>12,78=>13,79=>14,80=>15,81=>16,82=>17,83=>18,84=>19,85=>20,86=>21,87=>22,88=>23,89=>24,90=>25,97=>26,98=>27,99=>28,100=>29,101=>30,102=>31,103=>32,104=>33,105=>34,106=>35,107=>36,108=>37,109=>38,110=>39,111=>40,112=>41,113=>42,114=>43,115=>44,116=>45,117=>46,118=>47,119=>48,120=>49,121=>50,122=>51,48=>52,49=>53,50=>54,51=>55,52=>56,53=>57,54=>58,55=>59,56=>60,57=>61,43=>62,47=>63};
        List<Integer> lstOut = new List<Integer>();

        if ( sIn == null || sIn == '' ) return lstOut;
        //sIn += '='.repeat( 4 - Math.mod( sIn.length(), 4) );
         for ( Integer idx=0; idx < sIn.length(); idx += 4 ) {
            if ( base64.get(sIn.charAt(idx+1)) != null ) lstOut.add( (base64.get(sIn.charAt(idx)) << 2) | (base64.get(sIn.charAt(idx+1)) >>> 4) );
            if ( base64.get(sIn.charAt(idx+2)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+1)) & 15)<<4) | (base64.get(sIn.charAt(idx+2)) >>> 2) );
            if ( base64.get(sIn.charAt(idx+3)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+2)) & 3)<<6) | base64.get(sIn.charAt(idx+3)) );
        }
         System.Debug('B64ToBytes: [' + sIn + '] = ' + lstOut);
        return lstOut;
    }
    
     //Method to get binary Equivalent of a decimal number
    public static String decimalToBinaryString(Integer numberToConvert){

        String binary='';
        Integer remainder;
        if(numberToConvert>=0){
        while(numberToConvert > 0)
        {   
            remainder= math.mod(numberToConvert,2);          
            binary+=remainder.format();
            //System.debug('For '+numberToConvert+':'+binary);
            numberToConvert/=2;
        }
            binary=binary.reverse();
        if(binary.length()<8){          
            Integer diff=8-binary.length();
            for(Integer i=0;i<diff;i++){
                binary='0'+binary;      
            }
        }     
        return binary;
        }
        else{
            Integer maxRange=128;
            Integer difference=maxRange+numberToConvert;
            String tempString='';
            if(difference==0){
                binary='10000000';
            }
            else{
                
                while(difference > 0){  
                     remainder= math.mod(difference,2);          
                     tempString+=remainder.format();
                     difference/=2;
                }
                tempString=tempString.reverse();
                Integer length=7-tempString.length();
                if(length>0){
                    for(Integer i=0;i<length;i++){
                        tempString='0'+tempString;
                    }

                }   
                binary='1'+tempString;
            }
            
        }
        return binary;  
    }
    
    
    public static String  callOut(){
    Http http = new Http();
    // Getting value of encrypted challenge
    //URl for webservice
    String endPointForChallenge = 'http://auth-devint.zycus.com/ZygrateSecurity/rest/v1/auth/user';

    HttpRequest requestForChallenge=createRequest(endPointForChallenge,'GET',null);
    requestForChallenge.setHeader('x-zycus-applicationid', '37yPDNlpZP9uARetqKtupA==');
    requestForChallenge.setHeader('x-zycus-username', 'user1dev.Lowes.Zycusadmin@zycus.com');
    HttpResponse response = http.send(requestForChallenge);
    //System.debug(response.toString());
	
    
        
    String challenge=getResponseFromChallenge(response);
    //System.debug('Decrypted String:'+challenge);
	
      //Request for Access Token
     String endPointForAccessToken='http://auth-devint.zycus.com/ZygrateSecurity/rest/v1/auth/access-token';
     HttpRequest requestForAccessToken=createRequest(endPointForAccessToken,'GET',null);
     requestForAccessToken.setHeader('x-zycus-applicationid', '37yPDNlpZP9uARetqKtupA==');
     requestForAccessToken.setHeader('x-zycus-username', 'user1dev.Lowes.Zycusadmin@zycus.com');
    // requestForAccessToken.setHeader('Content-Type', 'application/json');
     List<String> headers=new List<String>();
     headers.add('x-zycus-applicationid');
     headers.add('x-zycus-username');
     String xZycusSignatureForAccessToken=generateSignature(requestForAccessToken,headers,challenge);
    // System.debug('Signature:'+xZycusSignatureForAccessToken);
     requestForAccessToken.setHeader('x-zycus-signature',xZycusSignatureForAccessToken);
     HttpResponse response1=http.send(requestForAccessToken);
   //  System.debug('response1'+response1);
     String accessToken=response1.getHeader('x-zycus-accesstoken');
         System.debug('accessToken: '+accessToken);
     Datetime currentTime=Datetime.now();
     String timeStamp=''+currentTime.getTime();
     //
     String endPointForRestRequest='http://api-devint.zycus.com/Zygrate/rest/v2/icontract/endpoint/api/contract/ff808081642c06e50164425e41de03c7';

    HttpRequest requestForRestCall=createRequest(endPointForRestRequest,'GET',null);
    /* String body='{'+'\n'+
   '\"IDS\":['+'\n'+
        '\"402883995451f14801545352b2de000a\",'+'\n'+
        '\"402883995451f1480154535258310009\"'+'\n'+
   '],'+'\n'+
  '\"ENTITIES\":['+'\n'+
         '\"CONTRACTING_PARTY\",'+'\n'+
		 '\"AMENDMENT\"'+'\n'+
   ']'+'\n'+
'}';*/
    // HttpRequest requestForRestCall=createRequest(endPointForRestRequest,'POST',body);
     requestForRestCall.setHeader('x-zycus-applicationid', '37yPDNlpZP9uARetqKtupA==');
     requestForRestCall.setHeader('x-zycus-username','user1dev.Lowes.Zycusadmin@zycus.com');
     requestForRestCall.setHeader('x-zycus-accesstoken',accessToken);
     requestForRestCall.setHeader('x-zycus-nonce',timeStamp);
   	 requestForRestCall.setHeader('Accept', 'application/json');
       //requestForRestCall.setHeader('Content-Type', 'application/json');
        // requestForRestCall.setHeader('x-zycus-tenantId','700ec916-0723-4378-a400-b7002b421edd');
        // requestForRestCall.setHeader('x-zycus-integrationTrackingNumber','c5c54e0a-d2eb-4561-a598-539c37bbdb13#0556826f-a54f-476f-b23f-91fe85ac404b');
     List<String> newHeadersForRestCall=new List<String>();
     newHeadersForRestCall.add('x-zycus-accesstoken');
     newHeadersForRestCall.add('x-zycus-applicationid');
     newHeadersForRestCall.add('x-zycus-nonce');
     newHeadersForRestCall.add('x-zycus-username');
        // newHeadersForRestCall.add('x-zycus-tenantId');
        // newHeadersForRestCall.add('x-zycus-integrationTrackingNumber');
     String xZycusSignatureForRestCall=generateSignature(requestForRestCall, newHeadersForRestCall, challenge);
     //System.debug('Signature For Rest call:'+xZycusSignatureForRestCall);
     requestForRestCall.setHeader('x-zycus-signature',xZycusSignatureForRestCall);
     requestForRestCall.setTimeout(120000); 
     HttpResponse response2=http.send(requestForRestCall);
     
     System.debug('response2:-'+response2.getBody());   
        
     Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response2.getBody());
     System.debug('response2:-'+results);   
    return challenge;
    }
    
   
    
    
    
    public static String getResponseFromChallenge(HttpResponse response){
         Http http=new Http();
         String challenge=response.getHeader('x-zycus-challenge'); 
         System.debug('Challenge:'+challenge);
         String endPoint = 'https://rmapi.procurewiseapp.com/procurewise/rest/v1/admin/decrypt';
         String method = 'GET';
         HttpRequest request = setRequest(endPoint, method, null,challenge);
		 HttpResponse decryptedChallengeResponse = http.send(request);
         Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(decryptedChallengeResponse.getBody());
         String decryptedChallenge=(String)results.get('result');
       //  System.debug('Response:'+decryptedChallenge);
         return decryptedChallenge;
        
        
               		/*
       		 * Code to checkEncryption and decryption
       		 * 
       		 *  String hello='Hello';
        	 String key='1234000000000000';
        	 String iv='0000000000000000';
        	 Blob dataBlob=Blob.valueOf(hello);
        	 Blob keyBlob=Blob.valueOf(key);
        	 Blob ivBlob=Blob.valueOf(iv);
        	 Blob encrypted=Crypto.encrypt('AES128',keyBlob,ivBlob,dataBlob);
        	 System.debug('Encrypted String:'+EncodingUtil.base64Encode(encrypted));*/
        
        	/*Integer[] arrayOfChars=new Integer[]{80, 97, 115, 115, 49, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};   
        	String mpin=String.fromCharArray(arrayOfChars);
        	Blob mpinBlob=Blob.valueOf(mpin);
        	System.debug('Mpin Size:'+mpinBlob.size()); 
         	
        	
        	String challenge=response.getHeader('x-zycus-challenge');   
       	    System.debug('challenge:'+challenge+' Challenge size:'+challenge.length()); 
        
       	 	Integer [] charsFromChallenge=challenge.getChars();
        	String b1='';
        	for(Integer i:charsFromChallenge){
            b1+=decimalToBinaryString(i);
        	}
        	System.debug(b1);
        //base64DecodedString represents base64 decryption of encrypted String
        	String base64DecodedString='';
        	for(Integer i=0;i<challenge.length();i++){  
            //As challenge is Base 64 Encoded first decoding it     
            base64DecodedString+=base64DecodeTable.get(challenge.substring(i,i+1)); 
        	}

        //Blob blobData123=Blob.valueOf()
        	System.debug('base64DecodedString:'+base64DecodedString);
        //Removing padding from decrypted String
        	base64DecodedString=base64DecodedString.subString(0,base64DecodedString.length()-16);
        	System.debug('Length of decrypted Base 64 data:'+base64DecodedString.length().format());
        //Hex String equivalent to the base64DecodedString
        String hexStringForData='';
        System.debug('hexStringForData:'+hexStringForData);
        for(Integer i=0;i<base64DecodedString.length()/4;i++){
            hexStringForData+= binaryToHexString(base64DecodedString.substring(i*4,(i+1)*4));
        }
        
        //hexStringForData+='3D';
        //data Blob to be used for data decryption
        //hexStringForData=EncodingUtil.urlEncode(hexStringForData,'UTF-8');
        Blob dataBlob=EncodingUtil.convertFromHex(hexStringForData);
        Blob decryptedBlob=Crypto.decryptWithManagedIV('AES128', mpinBlob, dataBlob);
        System.debug('Blob Size:'+decryptedBlob.size());*/
    }
    
    public static HttpRequest setRequest(String endPoint, String method, String body,String challenge)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('x-personId', '199');
        request.setMethod(method);
        String email = 'mahesh.chotrani@zycus.com';
        String password = 'pass@123';
        String utcString = Datetime.now().formatGMT('EEE, d MMM yyyy HH:mm:ss') + ' GMT';
       // utcString=Datetime.now().formatGMT('EEE, d MMM yyyy HH:mm:ss') + ' GMT';;
     //   System.debug(utcString);
        String authorization = getAuthorization(email, password, utcString);
        request.setHeader('Authorization', 'Digest ' + authorization);
        request.setHeader('Date', utcString);
        request.setHeader('encryptedString',challenge);
        request.setHeader('Version', '1.6');
        if(method.equalsIgnoreCase('POST'))
        {
            request.setHeader('Content-Type', 'application/json; charset=UTF-8');
            request.setBody(body);
        }
        return request;
    }
    
    private static String getAuthorization(String email, String password, String utcString)
    	{

        //generating nonce
        String nonce = '1234ganesh';
        // String nonceString=EncodingUtil.convertToHex(Blob.valueOf(nonce));

        //md5 for password
        Blob passwordBlob = Blob.valueOf(password);
        Blob md5passwordblob = Crypto.generateDigest('MD5', passwordBlob);
        String passwordString = EncodingUtil.base64Encode(md5passwordblob);
        passwordString = passwordString.replace('==', '');

        // String utf8PasswordString=EncodingUtil.urlDecode(passwordString,'UTF-8');

       // System.debug('passwordString:' + passwordString);

        //generating hash value
        String hashString = email + ':' + nonce + ':' + passwordString + ':' + utcString;
        Blob hashBlob = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hashValueString = EncodingUtil.base64Encode(hashBlob);
        hashValueString = hashValueString.replace('==', '');
        
       // System.debug('hashValueString:' + hashValueString);

        //generating private key
        Blob privateKey = Blob.valueOf('PROC_DIGEST_AUTH_KEY');
        Blob privateKeyEncoded = Crypto.generateDigest('SHA256', privateKey);
       // System.debug('privateKeyString:' + EncodingUtil.convertToHex(privateKeyEncoded));
        String privateKeyString = (EncodingUtil.convertToHex(privateKeyEncoded)).subString(0, 32);
        Integer[] privateKeyArray=privateKeyString.getChars();
       // System.debug('privateKeyArray'+privateKeyArray);
        Blob privateKeyNew = Blob.valueOf(privateKeyString);
        System.debug('privateKeySize:'+privateKeyNew.size());
        //System.debug('privateKeyString:'+privateKeyString);

        //generating initialization vector
        String iv = '80519a18be9df181';
        Blob ivBlob = Blob.valueOf(iv);

        //creating data for encryption
        String data = email + ':' + nonce + ':' + hashValueString;
        Blob dataBlob = Blob.valueOf(data);
       // System.debug('datablob size:'+dataBlob.size());
        
        //Encrypting data
        Blob encryptedData = Crypto.encrypt('AES256', privateKeyNew, ivBlob, dataBlob);
        System.debug('encryptedData:'+encryptedData.size());
        String encryptedString = EncodingUtil.base64Encode(encryptedData);
        Integer[] encryptedStringArray=encryptedString.getChars();
        System.debug('encryptedStringArray'+encryptedStringArray);
        System.debug(encryptedString);
        String modifiedEncryptedString = encryptedString.replace('/(\r\n|\n|\r)/gm', '');
        System.debug(modifiedEncryptedString);
        return modifiedEncryptedString;
    	}
    
    
    private static String generateSignature(HttpRequest request,List<String> headers,String challenge){
        String standardisedHeaders='';
        for(Integer i=0;i<headers.size();i++){
            if(i!=0){
                standardisedHeaders+='\n';
            }
            standardisedHeaders+=headers.get(i).toLowerCase()+':'+request.getHeader(headers.get(i));
        }
        //standardisedHeaders+=';';
        String methodForRequest=request.getMethod();
        methodForRequest=methodForRequest.toLowerCase(methodForRequest);
        String urlForRequest=request.getEndpoint();
        String body='';
        if(methodForRequest.equals('post')){
            body+='\n'+request.getBody();
        }
        String stringToBeSigned=methodForRequest+'\n'+urlForRequest+'\n'+standardisedHeaders+body;
       // System.debug('stringToBeSigned: '+stringToBeSigned);
        stringToBeSigned=stringToBeSigned.trim();
       	Blob challengeBlob=Blob.valueOf(challenge);
        Blob stringToBeSignedBlob=Blob.valueOf(stringToBeSigned);
        Blob signature=Crypto.generateMac('hmacSHA256', stringToBeSignedBlob, challengeBlob);   
        Integer[] signatureOriginal=B64ToBytes(EncodingUtil.base64Encode(signature));
        System.debug('array:'+signatureOriginal);
        String binarySignature='';
        for(Integer i:signatureOriginal){
            binarySignature+=decimalToBinaryString(i);
        	}
        	//System.debug(binarySignature);
        String hexSignature='';
        for(Integer i=0;i<binarySignature.length()/4;i++){
            hexSignature+= binaryToHexString(binarySignature.substring(i*4,(i+1)*4));
        }
        return hexSignature.toLowerCase();
        
    }   
}