
/* ************************************************************************* */
/*                                                                           */
/*  Title:       Client.hx                                                   */
/*                                                                           */
/*  Created on:  20.08.2016 at 02:52                                         */
/*  Email:       ovidiugabriel@gmail.com                                     */
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

class Client {
    static var URL : String = null;

    /**
        Set the URL of the Server endpoint
     **/
    static public function setURL( url : String ) : Void {
        Client.URL = url;
    }

    /**

     **/
    static private function defaultErrorHandler( err : Dynamic ) {
        var errstr =  Std.string(err);
        Logging.getConsole().error('Error: $errstr');
    }

    /**
        Gets the context for a HTTP connection to execute remote calls.
     **/
    static public function getConnection( className : String, ?errorHandler : Dynamic -> Void ) : HttpAsyncConnection
    {
        if (null == Client.URL) {
            throw "ERROR: URL is not set";
        }

        var cnx = HttpAsyncConnection.urlConnect(Client.URL + '/' + className);

        // Use the default error handler if not specified otherwise
        if (null == errorHandler) {
            errorHandler = defaultErrorHandler;
        }
        cnx.setErrorHandler( errorHandler );
        return cnx;
    }

    /**
         Remotely calls a procedure on the server and executes callback on result.
     **/
    static public function call( className : String, methodName : String, params : Array<Dynamic>,
        ?onResult : Dynamic -> Void,
        ?onError : Dynamic -> Void ) : Void
    {
        var conn : HttpAsyncConnection = getConnection(className, onError);
        if (null != conn) {
            conn.resolve(className).resolve(methodName).call(params, onResult);
            return;
        }
        throw "ERROR: No active connection";
    }
}
