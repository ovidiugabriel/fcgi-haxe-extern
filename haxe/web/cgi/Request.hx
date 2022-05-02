
package web.cgi;

import haxe.io.BytesData;
import haxe.ds.StringMap;

extern class Request {
    /** Retrieves the bytes that were read by an HTTP POST. **/
    public function binaryRead(count : Int) : BytesData ;

    /** Retrieves a cookie value by its name. **/
    public function getCookie() : String ;

    /** Retrieves all cookies. **/
    public function getCookies() : Array<Cookie> ;

    /** Retrieves the value of a specified name which was read by POST or GET method. **/
    public function getForm(name : String) : String ;

    /** Retrieves all values of a specified name which were read by POST or GET method. **/
    public function getForms(name : String) : Array<String> ;

    /** Retrieves all pairs of name and value that were read by POST or GET method. **/
    public function getFormNameValue() : StringMap<String> ;

    /** Retrieves a specified ServerVariable value. **/
    public function getServerVariable(variableName : String) : String ;

    /** Returns the size, in bytes, of the current request. **/
    public function getTotalBytes() : Int ;
}
