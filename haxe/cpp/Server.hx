
/* ************************************************************************* */
/*                                                                           */
/*  Title:       Server.hx                                                   */
/*                                                                           */
/*  Created on:  20.08.2016 at 02:52                                         */
/*  Email:       ovidiugabriel {at} gmail {punkt} com                        */
/*  Copyright:   (C) 2015-2022 SoftICE Development OU. All Rights Reserved.  */
/*                                                                           */
/*  $Id$                                                                     */
/*                                                                           */
/* ************************************************************************* */

/*
 * Copyright (c) 2015-2022, SoftICE Development OU.
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

import sys.io.FileOutput;

// If Dialog is not imported, Type.createInstance() will return null
// FIXME: Find a method to require dependencies in a custom project specific file.
import Dialog;

@:buildXml("
    <files id='haxe'>
        <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/cpp' />
     </files>
")
@:final
class Server {

    static public function processRequest( requestData : String, ctx : Context ) : String {
        var u = new haxe.Unserializer(requestData);
        var path : Array<String> = u.unserialize();
        var args : Array<Dynamic> = u.unserialize();
        var data = ctx.call(path, args);
        var s = new haxe.Serializer();
        s.serialize(data);
        return "hxr" + s.toString();
    }

    /**

     **/
    static public function handleRequest( ctx : Context ) : Bool {
        var v = Web.getParams().get("__x");
        if (v == null) {
            return false;
        }

        try {
            var output = processRequest(StringTools.urlDecode(v), ctx);
            Web.flush(); // flush the headers
            Sys.print(output);
        } catch(ex : Dynamic) {
            internalServerError();
            trace(ex);
            // TODO: print exception stack ...
            // TODO: add exception handler ...
            return false;
        }
        return true;
    }

    /**
        Sets the default exception handler if an exception is not caught within a try/catch block.
     **/
    static public function setExceptionHandler() {
        // push
    }

    /**
        Restores the previously defined exception handler function
     **/
    static public function restoreExceptionHandler() {
        // pop
    }

    static public function getPathInfo() : String {
        var pathInfo:String = Sys.getEnv("PATH_INFO");

        if (pathInfo.charAt(0) == '/') {
            pathInfo = pathInfo.substr(1);
        }
        return pathInfo;
    }

    static public function getClassName() : String {
        var v  = Web.getParams().get("__x");
        if (null == v) {
            return null;
        }

        try {
            var u = new haxe.Unserializer(StringTools.urlDecode(v));
            var path = u.unserialize();
            return path[0];
        } catch (ex : Dynamic) {
            trace(ex);
            Logging.info('ERROR: Could not unserialize parameter __x');
        }
        return null;
    }

    static private function notFound() {
        Web.setReturnCode(404);
    }

    static private function internalServerError() {
        Web.setReturnCode(500);
    }

    /**

     **/
    static public function main() {
        haxe.Log.trace = function(v : String, ?infos : haxe.PosInfos) {
            Logging.info(v);
        };

        var pathInfo : String = getClassName();

        if (null == pathInfo) {
            Logging.info("ERROR: Invalid request. No class name specified.");
            Server.notFound();
            return;
        }

        // FIXME: Is this really needed?
        var defaultHeaders = [
            "Access-Control-Allow-Origin" => "*",
            "Content-Type"                => "text/html",
            "Cache-Control"               => "no-cache, no-store, must-revalidate",
            "Pragma"                      => "no-cache",
            "Expires"                     => "0"
        ];

        //
        // The method to be executed is required to be an instance method
        // (as oposed to a static method which belogs to class, not to instance)
        //
        var instance = Type.createInstance(Type.resolveClass(pathInfo), []);
        if (null != instance) {

            for (key in defaultHeaders.keys()) {
                Web.setHeader(key, defaultHeaders[key]);
            }

            var ctx = new Context();
            ctx.addObject(pathInfo, instance);

            handleRequest(ctx);
        } else {
            Logging.info('ERROR: instance for "$pathInfo" is null');
            Server.notFound();
        }
    }
}
