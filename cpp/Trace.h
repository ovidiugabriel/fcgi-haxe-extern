
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

static void logMessage(std::string message) {
    std::ofstream outfile;
    outfile.open("./haxe.log", std::ios_base::app);
    outfile << message << std::endl;
}

#endif
