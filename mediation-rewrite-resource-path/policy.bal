import choreo/mediation;
import ballerina/http;

@mediation:InFlow
public function rewrite(http:Request req, mediation:Context ctx, string newPath) 
                                                                returns http:Response|false|error|() {
    if newPath[0] == "/" {
        ctx.resourcePath = newPath;
    } else {
        ctx.resourcePath = string `/${newPath}`;
    }

    return ();
}
