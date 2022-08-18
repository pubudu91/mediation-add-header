import choreo/mediation;
import ballerina/xmldata;
import ballerina/mime;
import ballerina/http;

@mediation:InFlow
public function xmlToJsonIn(http:Request req, mediation:Context ctx) returns http:Response|false|error|() {
    xml xmlPayload = check req.getXmlPayload();
    json jsonPayload = check xmldata:toJson(xmlPayload);
    req.setPayload(jsonPayload, mime:APPLICATION_JSON);
    return ();
}

@mediation:OutFlow
public function xmlToJsonOut(http:Response res, http:Request req, mediation:Context ctx) returns http:Response|false|error|() {
    xml xmlPayload = check res.getXmlPayload();
    json jsonPayload = check xmldata:toJson(xmlPayload);
    res.setPayload(jsonPayload, mime:APPLICATION_JSON);
    return ();
}

@mediation:FaultFlow
public function xmlToJsonFault(http:Response errorRes, error e, http:Response? res, http:Request req, mediation:Context ctx) returns http:Response|false|error|() {
    xml xmlPayload = check errorRes.getXmlPayload();
    json jsonPayload = check xmldata:toJson(xmlPayload);
    errorRes.setPayload(jsonPayload, mime:APPLICATION_JSON);
    return ();
}
