
#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <haxe/ds/StringMap.h>
#include <string>

#include "Client.h"
#include "NativeClient.h"

void TMain_main();

typedef void (*RowHandler)(int n, const char* row[]);
typedef void (*ErrorHandler)(const char* errstr);

// (private macros)
// This is how Haxe gets access to its own functions as callbacks
#define DYNAMIC_FUNC(className, funcName) ::className##_obj::funcName##_dyn()
#define BIND_NATIVE_CALLBACK(className, member, value) ::className##_obj::member = value

// Avoid defining public functions multiple times
#ifdef HX_DECLARE_MAIN 

class Entity {
public:
    double div;
};

static RowHandler gRowHandler = NULL;
void AttachRowHandler(RowHandler rowHandler) 
{
    gRowHandler = rowHandler;
}

static RowHandler gHeadHandler = NULL;
void AttachHeadHandler(RowHandler headHandler)
{
    gHeadHandler = headHandler;
}

static ErrorHandler gErrorHandler = NULL;
void AttachErrorHandler(ErrorHandler errorHandler) 
{
    gErrorHandler = errorHandler;
}

void RemoteCall( const char* className, const char* methodName, int argc, const char* argv[])
{
    // Convert argv to VirtualArray
    // Send an array of strings to the server
    ::cpp::VirtualArray params = ::cpp::VirtualArray_obj::__new(argc);
    int i;
    for (i = 0; i < argc; i++) {
        params->init(i, ::String(argv[i]));
    }    

    // Remote procedure call ...
    ::Client_obj::call(::String(className), ::String(methodName), params,
            // Dynamic Haxe callbacks as defined in Client.hx
            DYNAMIC_FUNC(NativeClient, callOnSuccess),
            DYNAMIC_FUNC(NativeClient, callOnError)
        );
}

void InternalResultHandler(int rowId, ::Array< ::String > row) 
{
    Int _g = 0;
    int i = 0;
    const char** vect = new const char*[row->length];
    while (_g < row->length) {
        ::String value = row->__get(_g);
        ++_g;
        ::cpp::Pointer<char> cstr = ::cpp::Pointer_obj::fromPointer(value.__s);
        vect[i] = (const char*) cstr;
        i++;
    }
    RowHandler handler = NULL;

    if ((rowId >= 0) && (NULL != gRowHandler)) {
        handler = gRowHandler;
    }

    if ((-1 == rowId) && (NULL != gHeadHandler)) {
        handler = gHeadHandler;
    }

    if (NULL != handler) {
        handler(row->length, vect);
    }
    delete vect;
}

void InternalErrorHandler(::String errstr) 
{
    printf("%s Error: %s\n", __FUNCTION__, (const char*) errstr);
    if (NULL != gErrorHandler) {
        gErrorHandler((const char*) errstr);
    }
}

#define LOG_ASSERT(x) ((void)((!(x)) && (printf("assert(" #x ") failed in %s:%d\n", __FILE__, __LINE__), 1) && (exit(1),1) ))

#define REMOTE_CALL(className, methodName, count, ...) \
    do { \
        AttachHeadHandler(ResultHandler<className>::headHandler); \
        AttachRowHandler(ResultHandler<className>::rowHandler); \
        const char* args[count] = __VA_ARGS__; \
        RemoteCall(#className, #methodName, (count), args); \
    } while (0)

// === Begin 'Dialog' definition

class Dialog {
    enum {
        Field_div
    };
public:
    static std::vector<Dialog*> objects;

    double mDiv;
    
    static void ValidateObject(int fieldCount, const char* row[]) {
        // Object members checking
        LOG_ASSERT( 1 == fieldCount );
        LOG_ASSERT( 0 == strcmp("div", row[Field_div]) );
    }

    Dialog(int fieldCount, const char* row[]) {
        LOG_ASSERT( 1 == fieldCount );
        LOG_ASSERT( 1 == sscanf(row[Field_div], "%lf", &(this->mDiv) ) );

        printf("%s %s div=%lf\n", __FUNCTION__, row[Field_div], this->mDiv);
    }
};
std::vector<Dialog*> Dialog::objects;

// === End 'Dialog' definition

// Public class ...
template<class T>
class ResultHandler {
public:
    static void rowHandler(int fieldCount, const char* row[]) 
    {
        T* obj = new T(fieldCount, row);
        T::objects.push_back(obj);
    }

    static void headHandler(int fieldCount, const char* row[])
    {
        T::ValidateObject(fieldCount, row);
    }
};

// This is the internal error handler... if not set...
static void DefaultErrorHandler(const char* message) 
{
    printf("[%s] %s\n", __FUNCTION__, message);
}

void TMain_main() 
{
    // Bind Private functions ...
    BIND_NATIVE_CALLBACK(NativeClient, onEachRow, InternalResultHandler);
    BIND_NATIVE_CALLBACK(NativeClient, onError, InternalErrorHandler);

    AttachErrorHandler(DefaultErrorHandler);

    // Public calls ...
    REMOTE_CALL(Dialog, div, 2, {"1", "2"});
    REMOTE_CALL(Dialog, div, 2, {"1", "0"});
}
#endif

#endif