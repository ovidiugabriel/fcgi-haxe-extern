
/* ************************************************************************* */
/*                                                                           */
/*  Title:       Web.h                                                       */
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

#ifndef WEB_H
#define WEB_H

//
// INCLUDE HEADERS
//

#include <stdlib.h>
#include <stdio.h>

#include <unordered_map>
#include <string>
#include <sstream>

#include <haxe/ds/StringMap.h>
#include <fstream>

//
// USING NAMESPACES AND IMPORTED TYPES
//

//
// USER DEFINED INCLUDES
//

#include "WebFunctions.cpp"
#include "Request.h"

//
// PUBLIC CLASS (PART OF THE INTERFACE WITH HAXE)
//

static std::unordered_map<std::string, std::string> headers;

class Web {
public:
    static hx::ObjectPtr<haxe::ds::StringMap_obj> getParams() {
        hx::ObjectPtr<haxe::ds::StringMap_obj> params = new haxe::ds::StringMap_obj();

        Request request;

        std::string base = GetCompleteQueryString( request.getPostData(), GetParamsString() );
        std::string part, key, value;
        std::string::size_type ppos = base.find("&");

        while (ppos != std::string::npos) {
            part = base.substr(0, ppos);
            key = ParseKey(part);
            if (!key.empty()) {
                value = ParseValue(part);
                params->set(::String(key.c_str()), ::String(value.c_str()));
            }
            base = base.substr(ppos + 1);
            ppos = base.find("&");
        }

        key = ParseKey(base);
        if (!key.empty()) {
            value = ParseValue(base);
            params->set(::String(key.c_str()), ::String(value.c_str()));
        }
        return params;
    }

    static void setReturnCode(int r) {
        std::string code;
        switch (r) {
            case 100: {code = "100 Continue"; break;}
            case 101: {code = "101 Switching Protocols"; break;}
            case 200: {code = "200 OK"; break;}
            case 201: {code = "201 Created"; break;}
            case 202: {code = "202 Accepted"; break;}
            case 203: {code = "203 Non-Authoritative Information"; break;}
            case 204: {code = "204 No Content"; break;}
            case 205: {code = "205 Reset Content"; break;}
            case 206: {code = "206 Partial Content"; break;}
            case 300: {code = "300 Multiple Choices"; break;}
            case 301: {code = "301 Moved Permanently"; break;}
            case 302: {code = "302 Found"; break;}
            case 303: {code = "303 See Other"; break;}
            case 304: {code = "304 Not Modified"; break;}
            case 305: {code = "305 Use Proxy"; break;}
            case 307: {code = "307 Temporary Redirect"; break;}
            case 400: {code = "400 Bad Request"; break;}
            case 401: {code = "401 Unauthorized"; break;}
            case 402: {code = "402 Payment Required"; break;}
            case 403: {code = "403 Forbidden"; break;}
            case 404: {code = "404 Not Found"; break;}
            case 405: {code = "405 Method Not Allowed"; break;}
            case 406: {code = "406 Not Acceptable"; break;}
            case 407: {code = "407 Proxy Authentication Required"; break;}
            case 408: {code = "408 Request Timeout"; break;}
            case 409: {code = "409 Conflict"; break;}
            case 410: {code = "410 Gone"; break;}
            case 411: {code = "411 Length Required"; break;}
            case 412: {code = "412 Precondition Failed"; break;}
            case 413: {code = "413 Request Entity Too Large"; break;}
            case 414: {code = "414 Request-URI Too Long"; break;}
            case 415: {code = "415 Unsupported Media Type"; break;}
            case 416: {code = "416 Requested Range Not Satisfiable"; break;}
            case 417: {code = "417 Expectation Failed"; break;}
            case 500: {code = "500 Internal Server Error"; break;}
            case 501: {code = "501 Not Implemented"; break;}
            case 502: {code = "502 Bad Gateway"; break;}
            case 503: {code = "503 Service Unavailable"; break;}
            case 504: {code = "504 Gateway Timeout"; break;}
            case 505: {code = "505 HTTP Version Not Supported"; break;}
            default: { code = ::String(r); break; }
        }

        //
        // FastCGI is using 'Status: 404 Not Found' instead of 'HTTP/1.0 404 Not Found'
        // that you may know from PHP
        //
        setHeader("Status", code.c_str());
    }

    static void setHeader(::String h, ::String v) {
        headers.insert(std::make_pair(h, v));
    }

    static void flush() {
        for (const auto& [h, v] : headers) {
            printf("%s: %s\r\n", h.c_str(), v.c_str());
        }
        headers.clear();
    }
};

#endif
