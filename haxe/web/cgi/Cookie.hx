
package web.cgi;

class Cookie {
    private var domain : String;
    private var path : String;
    private var name : String;
    private var value : String;
    private var maxAge : Int;
    private var secure : Bool;
    private var sameSite : String;
    private var httpOnly : Bool;

    //  Retrieve the Domain attribute of the cookie.
    public function getDomain() : String {
        return this.domain;
    }

    //  Retrieve maximum age of the cookie.
    public function getMaxAge() : Int {
        return this.maxAge;
    }

    //  Retrieve the name of the cookie.
    public function getName() : String {
        return this.name;
    }

    //  Retrieve the path on the server to which browser returns the cookie.
    public function getPath() : String {
        return this.path;
    }

    //  determine if the browser is sending the cookie only over a secure protocol.
    public function getSecure() : Bool {
        return this.secure;
    }

    //  Retrieve the value of the cookie.
    public function getValue() : String {
        return this.value;
    }

    // Set the Domain attribute of the cookie.
    public function setDomain(domain : String) : Void {
        this.domain = domain;
    }

    // Set maximum age of the cookie.
    public function setMaxAge(maxAge : Int) : Void {
        this.maxAge = maxAge;
    }

    // Set the name of the cookie.
    public function setName(name: String) : Void {
        this.name = name;
    }

    //  Set the path on the server to which browser returns the cookie.
    public function setPath(path : String) : Void {
        this.path = path;
    }

    // Set the Secure attribute of the cookie.
    public function setSecure(secure : Bool) : Void {
        this.secure = secure;
    }

    // Set the value of the cookie.
    public function setValue(value : String) : Void {
        this.value = value;
    }

    public function setSameSite(sameSite : String) : Void {
        this.sameSite = sameSite;
    }

    public function getSameSite() : String {
        return this.sameSite;
    }

    public function setHttpOnly(httpOnly : Bool) : Void {
        this.httpOnly = httpOnly;
    }

    public function getHttpOnly() : Bool {
        return this.httpOnly;
    }
}
