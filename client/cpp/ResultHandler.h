
#ifndef RESULT_HANDLER_H
#define RESULT_HANDLER_H

// Public class ...

template<class T>
class ResultHandler {
public:

    struct FinalFunctor {
        virtual void __call(std::vector<T>* userList) = 0;
    };

    static void rowHandler(void* objects, int fieldCount, const char* row[])
    {
        T obj(fieldCount, row);
        static_cast< std::vector<T>* >(objects)->push_back(obj);
    }

    static void finalHandler(void* callback, void* objects)
    {
        FinalFunctor* func = static_cast< ResultHandler<T>::FinalFunctor* >(callback);
        func->__call(static_cast< std::vector<T>* >(objects) );
    }

};

#endif