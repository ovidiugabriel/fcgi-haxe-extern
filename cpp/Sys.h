/*

*/

#ifndef SYS_H
#define SYS_H

#include <cstdio>
#include <cstdlib>

class Sys {
public:
    static int print(const char* v) {
        return printf("%s", v);
    }

    static int print(Float& v) {
        return printf("%f", v);
    }

    static ::String getEnv(const char* s) {
        return ::String(getenv(s));
    }

    static ::String systemName() {
        #if defined(_WIN32) || defined(__CYGWIN__)
            return ::String("Windows");
        #endif
    }
};

#endif // SYS_H
