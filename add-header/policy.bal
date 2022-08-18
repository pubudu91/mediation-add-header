import choreo/mediation;
import ballerina/http;

@mediation:InFlow
public function addHeader_In(http:Request req, mediation:Context ctx, string name, string value) 
                                                                returns http:Response|false|error|() {
    req.addHeader(name, value);
    return ();
}

@mediation:OutFlow
public function addHeader_Out(http:Response res, http:Request req, mediation:Context ctx, string name, string value) 
                                                                                returns http:Response|false|error|() {
    res.addHeader(name, value);
    return ();
}

@mediation:FaultFlow
public function addHeader_Fault(http:Response errorRes, error e, http:Response? res, http:Request req, 
                                mediation:Context ctx, string name, string value) returns http:Response|false|error|() {
    errorRes.addHeader(name, value);
    return ();
}
