
package web.cgi;

class Response {
    private var buffer : Bool;

    /** Adds a specified cookie with attributes **/
    public function addCookie(cookie : Cookie) : Int {
        return 0;
    }

    /** Adds a HTTP header to the HTTP response. **/
    public function addHeader(headerName : String, headerValue : String) : Int {
        return 0;
    }

    /** Sends buffered HTML output immediately. **/
    public function flush() : Int {
        return 0;
    }

    /**
     Retrieves the value of the Buffer property.

     If page output is buffered, true is returned. Otherwise, false is returned.
     **/
    public function getBuffer() : Bool {
        return this.buffer;
    }

    /** Retrieves the value for the CacheControl property. **/
    public function getCacheControl() : String {
        return "";
    }

    /** Retrieves the value for the CharSet property. **/
    public function getCharSet() : String {
        return "";
    }

    /** Retrieves the value of the ContentType property. **/
    public function getContentType() : String {
        return "";
    }

    /** Retrieves the value of the Expires property. **/
    public function getExpires() : Int {
        return 0;
    }

    /** Retrieves the value of the ExpiresAbsolute property. **/
    public function getExpiresAbsolute() : String {
        return "";
    }

    /** Retrieves the value of the Status property. **/
    public function getStatus() : String {
        return "";
    }

    /** Causes the browser to attempt to connect to a different URL. **/
    public function redirect(url : String) : Void {}

    /** Sets the value of the Buffer property. **/
    public function setBuffer(buffering : Bool) : Void {
        this.buffer = buffering;
    }

    /** Sets the value of the CacheControl property. **/
    public function setCacheControl(cacheControl : String) : Void {}

    /** Sets the value of the Charset property. **/
    public function setCharSet(charset : String) : Void {}

    /** Sets the value of the ContentType property. **/
    public function setContentType(contentType : String) : Void {}

    /** Sets the value of the Expires property. **/
    public function setExpires(expiresMinutes : Int) : Void {}

    /** Sets the value of the ExpiresAbsolute property. **/
    public function setExpiresAbsolute(expiresAbsolute : String) : Void {}

    /** Sets the value of the Status property. **/
    public function setStatus(status : String) : Void {}

}
