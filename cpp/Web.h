
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

#include <map>
#include <string>
#include <sstream>

#include <haxe/ds/StringMap.h>

//
// USING NAMESPACES AND IMPORTED TYPES
//

using namespace std;

//
// USER DEFINED INCLUDES
//

#include "WebFunctions.cpp"
#include "Request.h"

//
// PUBLIC CLASS (PART OF THE INTERFACE WITH HAXE)
//

class Web_obj {
public:
    static hx::ObjectPtr<haxe::ds::StringMap_obj> getParams() {
        TRACE( __FUNCTION__ );
        hx::ObjectPtr<haxe::ds::StringMap_obj> params = new haxe::ds::StringMap_obj();

        Request request;

        string base = GetCompleteQueryString( request.getPostData(), GetParamsString() );
        string part, key, value;
        std::string::size_type ppos = base.find("&");

        while (ppos != string::npos) {
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
};

#endif
