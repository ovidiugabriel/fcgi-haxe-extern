
package web.cgi;

import haxe.io.BytesData;
import haxe.ds.StringMap;

class Request {
    /**
        Retrieves the bytes that were read by an HTTP POST.
     **/
    public function binaryRead(count : Int) : BytesData {
        return new BytesData();
    }

    /**
        Retrieves a cookie value by its name.
     **/
    public function getCookie() : String {
        return "";
    }

    /** Retrieves all cookies. **/
    public function getCookies() : Array<Cookie> {
        return new Array<Cookie>();
    }

    /** Retrieves the value of a specified name which was read by POST or GET method. **/
    public function getForm(name : String) : String {
        return "";
    }

    /** Retrieves all values of a specified name which were read by POST or GET method. **/
    public function getForms(name : String) : Array<String> {
        return new Array<String>();
    }

    /** Retrieves all pairs of name and value that were read by POST or GET method. **/
    public function getFormNameValue() : StringMap<String> {
        return new StringMap();
    }

    /** Retrieves a specified ServerVariable value. **/
    public function getServerVariable(variableName : String) : String {
        return "";
    }

    /** Returns the size, in bytes, of the current request. **/
    public function getTotalBytes() : Int {
        return 0;
    }
}
