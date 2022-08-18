import choreo/mediation;
import ballerina/xmldata;
import ballerina/mime;
import ballerina/http;

@mediation:InFlow
public function jsonToXmlIn(http:Request req, mediation:Context ctx) returns http:Response|false|error|() {
    json jsonPayload = check req.getJsonPayload();
    xml? xmlPayload = check xmldata:fromJson(jsonPayload);

    if xmlPayload is () {
        http:Response errResp = new;
        errResp.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
        return errResp;
    }
    
    req.setXmlPayload(xmlPayload, mime:APPLICATION_XML);
    return ();
}

@mediation:OutFlow
public function jsonToXmlOut(http:Response res, http:Request req, mediation:Context ctx) returns http:Response|false|error|() {
    json jsonPayload = check res.getJsonPayload();
    xml? xmlPayload = check xmldata:fromJson(jsonPayload);

    if xmlPayload is () {
        http:Response errResp = new;
        errResp.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
        return errResp;
    }
    
    res.setXmlPayload(xmlPayload, mime:APPLICATION_XML);
    return ();
}
