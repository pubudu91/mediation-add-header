import ballerina/http;
import ballerina/test;

@test:Config {}
public function testPolicy() returns error? {
    http:Client ep = checkpanic new ("http://localhost:9090");
    http:Response resp = checkpanic ep->get("/hello?url=http://localhost:8080");
    string[] headers = check resp.getHeaders("bar");

    test:assertEquals(headers, ["Bar"]);
    test:assertEquals(resp.getJsonPayload(), <json>{"greeting": "Hello World!"});
}

@test:Config {}
public function testFaultFlow() returns error? {
    http:Client ep = checkpanic new ("http://localhost:9090");
    http:Response resp = checkpanic ep->get("/hello?url=http://localhost:8081");
    string[] headers = check resp.getHeaders("baz");

    test:assertEquals(headers, ["Baz"]);
    test:assertEquals(resp.statusCode, http:STATUS_INTERNAL_SERVER_ERROR);
}
