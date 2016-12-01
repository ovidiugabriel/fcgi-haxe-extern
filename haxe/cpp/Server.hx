
/* ************************************************************************* */
/*                                                                           */
/*  Title:       Server.hx                                                   */
/*                                                                           */
/*  Created on:  20.08.2016 at 02:52                                         */
/*  Email:       ovidiugabriel@gmail.com                                     */
/*  Copyright:   (C) 2015 ICE Control srl. All Rights Reserved.              */
/*                                                                           */
/*  $Id$                                                                     */
/*                                                                           */
/* ************************************************************************* */

/*
 * Copyright (c) 2015-2016, ICE Control srl.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package cpp;

import haxe.remoting.Context;
import haxe.remoting.HttpConnection;
import cpp.Web;

// If Dialog is not imported, Type.createInstance() will return null
// FIXME: Find a method to require dependencies in a custom project specific file.
import Dialog;

@:buildXml("
    <files id='haxe'>
        <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/cpp' />
     </files>
")
class Server {
    /**

     **/
    public static function handleRequest( ctx : Context ) : Bool {
        var v = Web.getParams().get("__x");
        if (v == null) {
            return false;
        }
        Sys.print(HttpConnection.processRequest(StringTools.urlDecode(v), ctx));
        return true;
    }

    /**

     **/
    static public function main() {

        var pathInfo:String = Sys.getEnv("PATH_INFO");

        if (pathInfo.charAt(0) == '"') {
            Sys.print("ERROR: Don't use quotes on Windows.\n");
            return;
        }

        if (pathInfo.charAt(0) == '/') {
            pathInfo = pathInfo.substr(1);
        }

        //
        // The method to be executed is required to be an instance method
        // (as oposed to a static method which belogs to class, not to instance)
        //
        var instance = Type.createInstance(Type.resolveClass(pathInfo), []);
        if (null != instance) {

            // Manually setting a CGI header for the response
            Sys.print("Access-Control-Allow-Origin: *\r\n");
            Sys.print("Access-Control-Allow-Headers: x-haxe-remoting\r\n");
            Sys.print("X-Powered-By: fcgi-haxe-extern https://github.com/ovidiugabriel/fcgi-haxe-extern\r\n");
            Sys.print("Content-Type: text/html\r\n");
            Sys.print("\r\n");

            var ctx = new haxe.remoting.Context();
            ctx.addObject(pathInfo, instance);

            handleRequest(ctx);
        } else {
            // TODO: Log error

            // FastCGI is using 'Status: 404 Not Found' instead of 'HTTP/1.0 404 Not Found' that you may know from PHP
            Sys.print("Status: 404 Not found\r\n");
            Sys.print("\r\n");
        }
    }
}
