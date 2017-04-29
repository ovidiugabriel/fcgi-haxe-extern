#ifndef REMOTE_H
#define REMOTE_H

#include <vector>
#include <string>

using std::vector;
using std::string;

// Protected interface
typedef void (*RowHandler)(void* obj, int n, const char* row[]);

// Public interface
typedef void (*ErrorHandler)(const char* errstr);
void AttachRowHandler(RowHandler rowHandler);

static void RemoteCall( const char* className, const char* methodName, int argc, const char* argv[]);

// ケンタマ
class RemoteDatabase {

    std::string mHostName;
    std::string mPort;
    std::string mDatabaseName;

    std::string mUserName;
    std::string mPassword;
public:

    RemoteDatabase(string host, string dbname, string port = "80") :
        mHostName(host),
        mDatabaseName(dbname),
        mPort(port)
    {

    }

    void setCredentials(std::string username, std::string passwd) {
        this->mUserName = username;
        this->mPassword = passwd;
    }

    const char* getURL() {
        return ("http://" + mHostName + ":" + mPort + "/" + mDatabaseName).c_str();
    }
};

template<class T>
class Remote {
    explicit Remote() {}
    typedef typename ResultHandler<T>::FinalFunctor FinalFunctor;
public:

    // Use REMOTE_TYPE() to create specializations of this constructor
    Remote(RemoteDatabase* db, std::string className, FinalFunctor* proxy) :
        mDb(db),
        mClassName(className),
        mProxy(proxy)
    {
        ::Client_obj::setURL( ::String( db->getURL() ) );
    }

    void call(std::string methodName, int argc, const char* argv[])
    {
        SetSearchCallback(this->mProxy);
        SetObjectsContainer(&this->objects);
        AttachRowHandler(ResultHandler<T>::rowHandler);
        RemoteCall(this->mClassName.c_str(), methodName.c_str(), argc, argv);
    }

    void call(std::string methodName, vector<string> args)
    {
        Params params(args);
        this->call(methodName, params.size(), params.values());
    }

private:

    RemoteDatabase* mDb;
    std::string mClassName;
    FinalFunctor* mProxy;

    std::vector<T> objects;

    class Params {
        friend class Remote;
        const char** params;
        int count;

        Params(vector<string> args) {
            this->count = args.size();
            this->params = new const char*[this->count];
            for (int i = 0; i < this->count; i++) {
                params[i] = args[i].c_str();
            }
        }

        ~Params() {
            delete this->params;
        }

        int size() {
            return this->count;
        }

        const char** values() {
            return this->params;
        }
    };
};

// (private macros)
// This is how Haxe gets access to its own functions as callbacks
#define DYNAMIC_FUNC(className, funcName) ::className##_obj::funcName##_dyn()

static void RemoteCall( const char* className, const char* methodName, int argc, const char* argv[])
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


#endif
