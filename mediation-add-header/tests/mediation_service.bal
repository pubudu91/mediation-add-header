import ballerina/http;
import ballerina/test;
import choreo/mediation;

service on new http:Listener(9090) {

    resource function get hello(http:Request req, http:Caller caller, string url) returns error? {
        mediation:Context mediationCtx = {httpMethod: "get", resourcePath: string `/greet`};
        http:Response? backendResponse;

        do {
            {
                var x = check addHeader_In(mediationCtx, req, "foo", "Foo");

                if x is false {
                    check caller->respond(http:INTERNAL_SERVER_ERROR);
                    return;
                } else if x is http:Response {
                    check caller->respond(x);
                    return;
                }
            }

            http:Client ep = checkpanic new (url);
            backendResponse = check ep->execute(mediationCtx.httpMethod, mediationCtx.resourcePath, req, targetType = http:Response);

            {
                var x = check addHeader_Out(mediationCtx, req, <http:Response>backendResponse, "bar", "Bar");

                if x is false {
                    check caller->respond(http:INTERNAL_SERVER_ERROR);
                    return;
                } else if x is http:Response {
                    check caller->respond(x);
                    return;
                }
            }

            check caller->respond(backendResponse);
        } on fail var e {
            http:Response errFlowResponse = new;
            errFlowResponse.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;

            {
                var v = addHeader_Fault(mediationCtx, req, backendResponse, errFlowResponse, e, "baz", "Baz");

                if v is false|error {
                    check caller->respond(errFlowResponse);
                    return;
                } else if v is http:Response {
                    check caller->respond(v);
                    return;
                }
            }

            check caller->respond(errFlowResponse);
        }
    }
}

service on new http:Listener(8080) {
    resource function get greet(http:Request req) returns json {
        string[]|http:HeaderNotFoundError headers = req.getHeaders("foo");

        if headers is http:HeaderNotFoundError {
            test:assertFail("Header 'foo' not found");
        }

        test:assertEquals(headers, ["Foo"]);
        return {"greeting": "Hello World!"};
    }
}
