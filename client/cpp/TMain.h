
#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>

#include "Client.h"

void TMain_main();
void TClient_display(::Dynamic v);
void TClient_onError(::String errstr);

typedef void (*SuccessCallback)(::Dynamic v);
typedef void (*ErrorCallback)(::String errstr);

// This is how Haxe gets access to its own functions as callbacks
#define DYNAMIC_FUNC(className, funcName) ::className##_obj::funcName##_dyn()

// Avoid defining public functions multiple times
#ifdef HX_DECLARE_MAIN 

void RemoteCall( const char* className, const char* methodName,
    int argc, const char* argv[], SuccessCallback onSuccessCb,
    ErrorCallback onErrorCb )  
{
    // Convert argv to VirtualArray
    // Send an array of strings to the server
    ::cpp::VirtualArray params = ::cpp::VirtualArray_obj::__new(argc);
    int i;
    for (i = 0; i < argc; i++) {
        params->init(i, ::String(argv[i]));
    }

    // Bind native callbacks
    ::Client_obj::onSuccess = onSuccessCb;
    ::Client_obj::onError = onErrorCb;

    // Remote procedure call ...
    ::Client_obj::call(::String(className), ::String(methodName), params,
            // Dynamic Haxe callbacks as defined in Client.hx
            DYNAMIC_FUNC(Client, callOnSuccess),
            DYNAMIC_FUNC(Client, callOnError)
        );
}

void TClient_display(::Dynamic v) {
    printf("%s\n", "TClient_display");
    printf("%f\n", (double) v );
}

void TClient_onError(::String errstr) {
    printf("%s\n", "TClient_onError");
    printf("Error: %s\n", (const char*) errstr);
}

void TMain_main() {
    const char* args[] = {"1", "2"};
    RemoteCall("Dialog", "div", 2, args, TClient_display, TClient_onError);

    args[1] = "0";
    RemoteCall("Dialog", "div", 2, args, TClient_display, TClient_onError);
}
#endif

#endif