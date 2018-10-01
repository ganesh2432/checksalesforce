public class Procurewise
{
    public class Supplier
    {
        public  Long id {get; set;}
        public  Long endorse_count {get; set;}
        public  String legalStructure {get; set;}
        public  String website {get; set;}
        public String email {get; set;}
        public String phone {get; set;}
        public Long  noOfEmployees {get; set;}
        public  Double grossAnnualSales {get; set;}
        public  String diversityCode {get; set;}
        public  String paymentTerms {get; set;}
        public  String name {get; set;}
        public  SET<Commodity> commodities {get; set;}
        public    double overallRating {get; set;}
 
        public   Long createdDate;
        public Long getCreatedDate(){
            return createdDate;
        }
        public void setCreatedDate(Long createdDate){
            this.createdDate=createdDate;
            this.setCreatedDateTime(createdDate);
        }
        public   Long updatedDate;
        public Long getUpdatedDate(){
            return updatedDate;
        }
         public void setUpdatedDate(Long updatedDate){
            this.updatedDate=updatedDate;
            this.setUpdatedDateTime(updatedDate);
        }
        public Datetime createdDateTime;
         public Datetime updatedDateTime;
         public DateTime getCreatedDateTime()
        {
            return createdDateTime;
        }
        public DateTime getUpdatedDateTime()
        {
            return updatedDateTime;
        }
        public void setCreatedDateTime(Long createdDate)
        {
            createdDateTime = Datetime.newInstance(createdDate);
        }
        public void setUpdatedDateTime(Long updatedDate)
        {
            updatedDateTime = Datetime.newInstance(updatedDate);
        }
        public   Long ratingCount {get; set;}
        public    List<SupplierAddress> supplierAddressList {get; set;}
        public    String commaSeparatedCommodities {get; set;}
        
        
    }

    public class Commodity
    {
        public    String name {get; set;}
    }

    public class SupplierAddress
    {
        public   String state {get; set;}
        public String city {get; set;}
    }


    public  class SupplierSearchDTO
    {
        public List<Long> commodities {get; set;}
        public List<String> states {get; set;}
        public String supplierName {get; set;}

        public void setSupplierName(String supplierName)
        {
            this.supplierName = supplierName;
        }
        public String orderBy {get; set;}
        public Long sortOrder {get; set;}

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

        System.debug('passwordString:' + passwordString);

        //generating hash value
        String hashString = email + ':' + nonce + ':' + passwordString + ':' + utcString;
        Blob hashBlob = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hashValueString = EncodingUtil.base64Encode(hashBlob);
        hashValueString = hashValueString.replace('==', '');
        String utf8hashValueString = EncodingUtil.urlDecode(hashValueString, 'UTF-8');
        System.debug('hashValueString:' + hashValueString);

        //generating private key
        Blob privateKey = Blob.valueOf('PROC_DIGEST_AUTH_KEY');
        Blob privateKeyEncoded = Crypto.generateDigest('SHA256', privateKey);
        System.debug('privateKeyString:' + EncodingUtil.convertToHex(privateKeyEncoded));
        String privateKeyString = (EncodingUtil.convertToHex(privateKeyEncoded)).subString(0, 32);
        Integer[] privateKeyArray=privateKeyString.getChars();
        System.debug('privateKeyArray'+privateKeyArray);
        Blob privateKeyNew = Blob.valueOf(privateKeyString);
        System.debug('privateKeySize:'+privateKeyNew.size());
        //System.debug('privateKeyString:'+privateKeyString);

        //generating initialization vector
        String iv = '80519a18be9df181';
        Blob ivBlob = Blob.valueOf(iv);

        //creating data for encryption
        String data = email + ':' + nonce + ':' + hashValueString;
        Blob dataBlob = Blob.valueOf(data);
        System.debug('datablob size:'+dataBlob.size());
        
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


    public static List<Supplier> getResults(String supplierName)
    {
        Http http = new Http();
        SupplierSearchDTO supplierSearchDTO = new SupplierSearchDTO();
        supplierSearchDTO.commodities = new List<Long>();
        supplierSearchDTO.states = new List<String>();
        supplierSearchDTO.setSupplierName(supplierName);
        supplierSearchDTO.orderBy = '';
        supplierSearchDTO.sortOrder = 1;
        String body = json.serialize(supplierSearchDTO);
        String endPoint = 'https://rmapi.procurewiseapp.com/procurewise/rest/v1/suppliers/searchResults';
        String method = 'POST';
        System.debug(body);
        HttpRequest request = setRequest(endPoint, method, body);

        HttpResponse response = http.send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Object data = (Object) results.get('data');
        System.debug(data);
        String suppliersJSON = JSON.serializePretty(data);
        List<Supplier> suppliers;
        if (response.getStatusCode() == 200)
        {
            suppliers = (List<Supplier>)JSON.deserialize(suppliersJSON, List<Supplier>.class);
            for(Supplier supplier : suppliers)
            {
                supplier.setCreatedDateTime(supplier.getCreatedDate());

                supplier.setUpdatedDateTime(supplier.getUpdatedDate());
            }
            System.debug(suppliers);
        }
        return suppliers;
    }

    public static HttpRequest setRequest(String endPoint, String method, String body)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('x-personId', '199');
        request.setMethod(method);
        String email = 'mahesh.chotrani@zycus.com';
        String password = 'pass@123';
        String utcString = Datetime.now().formatGMT('EEE, d MMM yyyy HH:mm:ss') + ' GMT';
       // utcString=Datetime.now().formatGMT('EEE, d MMM yyyy HH:mm:ss') + ' GMT';;
        System.debug(utcString);
        String authorization = getAuthorization(email, password, utcString);
        request.setHeader('Authorization', 'Digest ' + authorization);
        request.setHeader('Date', utcString);
        request.setHeader('Version', '1.6');
        if(method.equalsIgnoreCase('POST'))
        {
            request.setHeader('Content-Type', 'application/json; charset=UTF-8');
            request.setBody(body);
        }
        return request;
    }

    public static List<Supplier> callout()
    {	
        String encodedData='JVBERi0xLjcNJcjIyMjIyMgNMSAwIG9iago8PC9UeXBlL0NhdGFsb2cvVmVyc2lvbi8xLjcvUGFnZXMgMyAwIFIvT3V0bGluZXMgMiAwIFIvTWV0YWRhdGEgMjcgMCBSPj4NCmVuZG9iagoyIDAgb2JqCjw8L1R5cGUvT3V0bGluZXMvQ291bnQgMD4+DQplbmRvYmoKMyAwIG9iago8PC9UeXBlL1BhZ2VzL0tpZHNbOCAwIFJdL0NvdW50IDE+Pg0KZW5kb2JqCjQgMCBvYmoKPDwvQXV0aG9yKCkvQ3JlYXRpb25EYXRlKEQ6MjAxODA3MjMyMDIyMzMrMDUnMzAnKS9Nb2REYXRlKEQ6MjAxODA3MjMyMDIyMzMrMDUnMzAnKS9Qcm9kdWNlcihBc3Bvc2UuUGRmIGZvciBKYXZhIDE3LjExKS9TdWJqZWN0KCkvVGl0bGUoKS9DcmVhdG9yKEFzcG9zZSBMdGQuKT4';
        Blob blob1=Blob.valueOf(encodedData);
        Integer[] array1=encodedData.getChars();
        System.debug(array1);
        Blob digest=Crypto.generateDigest('SHA512', blob1);
        System.debug(EncodingUtil.convertToHex(digest));
        
        
        Http http = new Http();
        String endPoint = 'https://rmapi.procurewiseapp.com/procurewise/rest/v1/suppliers/homeFeed';
        String method = 'GET';
        HttpRequest request = setRequest(endPoint, method, null);
        HttpResponse response = http.send(request);
         System.debug(response);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Object data = (Object) results.get('data');
        System.debug(data);
        String suppliersJSON = JSON.serializePretty(data);
        List<Supplier> suppliers;
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200)
        {
            suppliers = (List<Supplier>)JSON.deserialize(suppliersJSON, List<Supplier>.class);
            for(Supplier supplier : suppliers)
            {
                supplier.setCreatedDateTime(supplier.getCreatedDate());

                supplier.setUpdatedDateTime(supplier.getUpdatedDate());
            }
            System.debug(suppliers);
        }
        return suppliers;
    }

}