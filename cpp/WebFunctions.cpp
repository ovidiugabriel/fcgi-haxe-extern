
/* ************************************************************************* */
/*                                                                           */
/*  Title:       web-functions.cpp                                           */
/*                                                                           */
/*  Created on:  21.08.2016 at 07:56                                         */
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

#include "trace.h"

static int GetPostLength()
{
    // TRACE( __FUNCTION__ );
    int ret = 0;
    char *clen = getenv("CONTENT_LENGTH");
    if (clen == NULL) {
        return ret;
    } else {
        std::string slen(clen);
        std::stringstream stream(slen);
        stream >> ret;
        return ret;
    }
}

static std::string GetPostData()
{
    static char* c = NULL;
    // TRACE( __FUNCTION__ );

    int length = GetPostLength();
    if (length == 0) {              // POST data is empty
        return "";
    }
    if (length > 262144) {length = 262144;}

    if (NULL == c) {

        c = new char[length + 1];

        memset(c, 0, sizeof(c));
        char ch;
        for (int i = 0; i < length; i++) {
            ch = fgetc(stdin);
            if (ch == EOF) {
                break;
            }
            c[i] = ch;
        }
    }
    std::string data(c, length);

    return data;
}

static std::string GetParamsString()
{
    // TRACE( __FUNCTION__ );
    const char *s = getenv("QUERY_STRING");
    return (s != NULL) ? std::string(s) : std::string("");
}

static std::string GetCompleteQueryString(std::string post, std::string get)
{
    // TRACE( __FUNCTION__ );
    std::string base = "";
    if (post.length() != 0) {
        base.append(post);
    }
    if ((get.length() != 0) && (post.length() != 0)) {
        base.append("&");
    }
    if (get.length() != 0) {
        base.append(get);
    }
    return base;
}

static std::string ParseKey(std::string data)
{
    // TRACE( __FUNCTION__ );
    std::string::size_type pos = data.find("=");
    if (pos != std::string::npos) {
        return data.substr(0,pos);
    }
    return data;
}

static std::string ParseValue(std::string data)
{
    // TRACE( __FUNCTION__ );
    std::string::size_type pos = data.find("=");
    if (pos != std::string::npos) {
        return data.substr(pos+1);
    }
    return "";
}
