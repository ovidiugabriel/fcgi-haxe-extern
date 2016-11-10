
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
 * Copyright (c) 2015, ICE Control srl.
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
        // Manually setting a CGI header for the response
        Sys.print("Access-Control-Allow-Origin: *\r\n");
        Sys.print("Access-Control-Allow-Headers: x-haxe-remoting\r\n");
        Sys.print("Content-Type: text/html\r\n");
        Sys.print("\r\n");

        var pathInfo = Sys.getEnv("PATH_INFO");
        if (pathInfo.charAt(0) == '/') {
            pathInfo = pathInfo.substr(1);
        }

        var ctx = new haxe.remoting.Context();
        ctx.addObject(pathInfo, Type.createInstance(Type.resolveClass(pathInfo), [] ));

        handleRequest(ctx);
    }
}
