
#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <haxe/ds/StringMap.h>
#include <string>

#include "Client.h"
#include "NativeClient.h"


#include "ResultHandler.h"
#include "Remote.h"

void TMain_main();

// Public interface
typedef void (*ErrorHandler)(const char* errstr);

// Protected interface
typedef void (*RowHandler)(void* obj, int n, const char* row[]);

#define LOG_ASSERT(x) ((void)((!(x)) && (printf("assert(" #x ") failed in %s:%d\n", __FILE__, __LINE__), 1) && (exit(1),1) ))


// Avoid defining public functions multiple times
#ifdef HX_DECLARE_MAIN

#include "Dialog.h"

typedef void (*FinalHandler)(void* callback, void* objects);

// Private (static) variables
static RowHandler   gRowHandler   = NULL;
static ErrorHandler gErrorHandler = NULL;
static FinalHandler gFinalHandler = NULL;

// Pointer to object that implements __call()
static void* gSearchCallback = NULL;
static void* gObjects = NULL;

#define COUNT(x)        ((signed int)(sizeof(x)/sizeof((x)[0])))

void AttachFinalHandler(FinalHandler finalHandler)
{
    LOG_ASSERT(NULL != finalHandler);
    gFinalHandler = finalHandler;
}

void AttachRowHandler(RowHandler rowHandler)
{

    LOG_ASSERT(NULL != rowHandler);
    gRowHandler = rowHandler;
}

void AttachErrorHandler(ErrorHandler errorHandler)
{
    printf("%s %p\n", __FUNCTION__, errorHandler);
    LOG_ASSERT(NULL != errorHandler);
    gErrorHandler = errorHandler;
}

void SetObjectsContainer(void* obj)
{
    LOG_ASSERT(NULL != obj);
    gObjects = obj;
}

static void InternalResultHandler(int rowId, ::Array< ::String > row)
{
    int i = 0;
    const char** vect = new const char*[row->length];
    while (i < row->length) {
        ::String value = row->__get(i);
        ::cpp::Pointer<char> cstr = ::cpp::Pointer_obj::fromPointer(value.__s);
        vect[i] = (const char*) cstr;
        i++;
    }
    RowHandler handler = NULL;

    if ((rowId >= 0) && (NULL != gRowHandler)) {
        handler = gRowHandler;
    }

    if (NULL != handler) {
        handler(gObjects, row->length, vect);
    }
    delete vect;
}

// This is the internal error handler... if not set...
static void DefaultErrorHandler(const char* message)
{
    printf("TMain.h:%d DefaultErrorHandler\n", __LINE__);
    throw std::string(message);
}

void InternalErrorHandler(::String errstr)
{
    printf("%s:%d %s\n", __FILE__, __LINE__, __FUNCTION__);
    if (NULL != gErrorHandler) {
        printf("gErrorHandler: %p\n", gErrorHandler);
        gErrorHandler((const char*) errstr);
    } else {
        DefaultErrorHandler(errstr.c_str());
    }
}

void SetSearchCallback(void* searchCallback)
{
    LOG_ASSERT(NULL != searchCallback);
    gSearchCallback = searchCallback;
}

void InternalResultDone()
{
    LOG_ASSERT(NULL != gFinalHandler);
    LOG_ASSERT(NULL != gSearchCallback);
    LOG_ASSERT(NULL != gObjects);

    if (gFinalHandler && gSearchCallback && gObjects) {
        gFinalHandler(gSearchCallback, gObjects);
    }
}

#define BIND_NATIVE_CALLBACK(className, member, value) do { \
        ::className##_obj::member = value; \
    } while(0)

// Handlers are registered by Remote class
#define REMOTE_CALL(proxy, db, className, op, ...) do { \
        Remote<className> remote((db), #className, (proxy)); \
        const char* params[] = __VA_ARGS__; \
        remote.call(#op, COUNT(params), params); \
    } while(0)

struct UserSearchCallbackProxy : public ResultHandler<Dialog>::FinalFunctor {
    void __call(std::vector<Dialog>* userList) {

        for (std::vector<Dialog>::iterator it = userList->begin(); it != userList->end(); it++) {
            printf("f=%f\n", it->mDiv);
        }
    }
};

void TMain_main()
{
    BIND_NATIVE_CALLBACK(NativeClient, onEachRow, InternalResultHandler);
    BIND_NATIVE_CALLBACK(NativeClient, onDone, InternalResultDone);
    BIND_NATIVE_CALLBACK(NativeClient, onError, InternalErrorHandler);

    AttachErrorHandler(DefaultErrorHandler);

    // Why call this here???
    AttachFinalHandler(ResultHandler<Dialog>::finalHandler);

    UserSearchCallbackProxy proxy;
    ServiceEndpoint db("localhost", "cgi-bin/Server.exe");

    try {
        REMOTE_CALL(&proxy, &db, Dialog, div, {"1", "2"});
        REMOTE_CALL(&proxy, &db, Dialog, div, {"1", "0"});
    } catch (std::string errmsg) {
        fprintf(stderr, "Exception Caught - Error: %s\n", errmsg.c_str());
    }
}
#endif

#endif