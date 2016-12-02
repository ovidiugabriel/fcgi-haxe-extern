/*

*/

#ifndef SYS_H
#define SYS_H

#include <cstdio>
#include <cstdlib>

class Sys_obj {
public:
    static int print(const char* v) {
        return printf("%s", v);
    }

    static int print(Float& v) {
        return printf("%f", v);
    }

    static String getEnv(const char* s) {
        return ::String(getenv(s));
    }
};

#endif
