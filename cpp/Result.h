#ifndef RESULT_H
#define RESULT_H

#include <string>

template <typename T>
class Result {
    bool fException;
    std::string message;
    T normalResult;

public:

    Result() {
        this->fException = false;
    }

    void setException(std::string message) {
        this->message    = message;
        this->fException = true;
    }

    void setNormalResult(T result) {
        this->normalResult = result;
    }

    bool isException() {
        return this->fException;
    }

    T getResult() {
        return this->normalResult;
    }

    ::String getMessage() {
        return ::String(this->message.c_str());
    }
};

template<typename Container, typename... Rest>
Result<Container> testException(Container(*fun)(Rest...), Rest... params)
{
    Result<Container> result;
    try {
        result.setNormalResult(fun(params...));
    }

    #if 0
    catch (QSqlError error) {
        result.setException(error.text().toStdString());
    }
    #endif

    catch (std::string error) {
        result.setException(error);
    }
    return result;
}

#endif /* RESULT_H */
