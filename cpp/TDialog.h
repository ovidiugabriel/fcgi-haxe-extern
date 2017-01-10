#ifndef INCLUDED_TDialog
#define INCLUDED_TDialog

#include "Result.h"

static double original_div(double x, double y) {
    if (0 == y) {
        throw std::string("division by zero");
    }
    return x / y;
}

class TDialog {
public:

    /**
     * Performs a division returning either a double result or an exception message.
     */
    static Result<double> div(double x, double y) {
        return testException<double>(original_div, x, y);
    }
};

#endif /* INCLUDED_Dialog */
