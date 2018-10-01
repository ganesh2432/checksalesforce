global class CreateContractMockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"IntegrationEntities":{"integrationEntity":[{"integrationEntityHeader":{"integrationTrackingNumber":"115#4ff0449c-984c-49b5-9c9a-c6d7c0942ca9#99711121-f52d-4759-86ff-37ebc998a909#1527680820090","referenceCodeForEntity":"contractHierarchy","additionalInfo":null},"integrationEntityDetails":{"acknowledgement":{"id":"ff8080816541acc7016542566fcf0018","externalId":"test","status":"SUCCESS"}}}]}}');
        res.setStatusCode(200);
        return res;
    }

}