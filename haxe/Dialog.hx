

/*
 * Recommended presentation: https://www.youtube.com/watch?v=k2rw7-uL6RU
 */

import haxe.ds.StringMap;

#if cpp
// Available only with a C++11 compiler
/*
@:buildXml("
    <files id='haxe'>
        <compilerflag value='-std=c++11' />
     </files>
")
*/
// @:headerCode('#include "TDialog.h"')
#end
class Dialog {
    public function new() {}

    public function div( x : Float, y : Float ) : Array<Array<Dynamic>> {
        Logging.info('Dialog.div');
        /*
        #if cpp
            untyped __cpp__('Result<double> result = TDialog::div(x, y)');
            return cpp.CatchException.getResult();
        #else
        */
/*
        if (0 == y) {
            Logging.info('throwing Dialog.div');
            throw "division by zero";
        }
        */
        var result = new Array<Array<Dynamic>>();

        // Header (names of fields)
        var header = new Array<String>();
        header.push("div");
        result.push(header);

        var row:Array<Dynamic>;

        // First row
        row = new Array<Dynamic>();
        row.push(x/y);
        result.push(row);

        // Second row
        row = new Array<Dynamic>();
        row.push(x/y);
        result.push(row);

        Logging.info('result = ' + result.toString());

        return result;
    }
}
