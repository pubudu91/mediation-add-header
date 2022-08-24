import ballerina/http;
import ballerina/test;

@test:Config {}
public function testInFlowSingleInstance() {
    http:Request req = new;
    http:Response|false|error|() result = addHeader_In(req, {httpMethod: "get", resourcePath: "/greet"}, "x-foo", "FooIn");
    assertResult(result, req.getHeaders("x-foo"), "FooIn");
}

@test:Config {}
public function testOutFlowSingleInstance() {
    http:Response res = new;
    http:Response|false|error|() result = addHeader_Out(res, new, {httpMethod: "get", resourcePath: "/greet"}, "x-foo", "FooOut");
    assertResult(result, res.getHeaders("x-foo"), "FooOut");
}

@test:Config {}
public function testFaultFlowSingleInstance() {
    http:Response errRes = new;
    http:Response|false|error|() result = addHeader_Fault(errRes, error("Error"), (), new, {httpMethod: "get", resourcePath: "/greet"}, "x-foo", "FooFault");
    assertResult(result, errRes.getHeaders("x-foo"), "FooFault");
}

@test:Config {}
public function testInFlowMultipleInstances() {
    http:Request req = new;
    http:Response|false|error|() result = addHeader_In(req, {httpMethod: "get", resourcePath: "/greet"}, "x-foo", "FooIn1");
    assertResult(result, req.getHeaders("x-foo"), "FooIn1");

    result = addHeader_In(req, {httpMethod: "get", resourcePath: "/greet"}, "x-bar", "BarIn");
    assertResult(result, req.getHeaders("x-bar"), "BarIn");
    
    result = addHeader_In(req, {httpMethod: "get", resourcePath: "/greet"}, "x-foo", "FooIn2");
    assertResult(result, req.getHeaders("x-foo"), "FooIn1", "FooIn2");
}

function assertResult(http:Response|false|error|() result, string[]|http:HeaderNotFoundError headers, string... expVal) {
    if !(result is ()) {
        test:assertFail("Expected '()', found " + (typeof result).toString());
    }

    if headers is http:HeaderNotFoundError {
        test:assertFail("Header 'x-foo' not found in the request");
    }

    test:assertEquals(headers, expVal);
}
