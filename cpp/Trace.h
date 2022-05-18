
#ifndef TRACE_H
#define TRACE_H

#include <string>
#include <fstream>

//
// LOCAL MACRO DEFINITIONS
//

static void logMessage(std::string message) {
    std::ofstream outfile;
    outfile.open("./haxe.log", std::ios_base::app);
    outfile << message << std::endl;
}

#endif
