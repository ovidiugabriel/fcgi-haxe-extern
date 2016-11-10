
#ifndef TRACE_H
#define TRACE_H

//
// LOCAL MACRO DEFINITIONS
//

#ifdef DEBUG
    #define TRACE(msg)  printf("%s:%d: %s\n", __FILE__, __LINE__, (msg))
#else
    #define TRACE(...)
#endif

#endif