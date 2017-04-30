
#ifndef DIALOG_H
#define DIALOG_H


class Dialog {
    enum {
        Field_div
    };
public:
    double mDiv;

    Dialog(int fieldCount, const char* row[]) {
        LOG_ASSERT( 1 == fieldCount );
        LOG_ASSERT( 1 == sscanf(row[Field_div], "%lf", &(this->mDiv) ) );
    }
};

#endif