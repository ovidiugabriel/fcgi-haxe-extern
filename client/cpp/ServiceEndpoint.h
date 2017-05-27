#ifndef SERVICE_ENDPOINT_H
#define SERVICE_ENDPOINT_H

#include <string>

class ServiceEndpoint {

    std::string mHostName;
    std::string mPort;
    std::string mDatabaseName;

    std::string mUserName;
    std::string mPassword;
public:

    ServiceEndpoint(std::string host, std::string dbname, std::string port = "80") :
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

#endif/* SERVICE_ENDPOINT_H */