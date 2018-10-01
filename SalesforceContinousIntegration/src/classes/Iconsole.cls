public class Iconsole {

    public static String  callOut(){
	Http http = new Http();
	String endPoint = 'http://192.168.1.92:48080/ZygrateSecurity/rest/v1/auth/user';
	HttpRequest request=new HttpRequest();
	request.setEndpoint(endPoint);
	request.setHeader('x-zycus-applicationid', 'prEyyv5RbXWkOMaMmmT5Zw==');
	request.setHeader('x-zycus-username', 'isource.user@zycus.com');
	request.setMethod('GET');
	HttpResponse response = http.send(request);
	System.debug(response.toString());
	return response.toString();
	}

}