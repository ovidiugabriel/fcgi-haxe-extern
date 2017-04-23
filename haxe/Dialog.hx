

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

    public function div( x : Float, y : Float ) : Array<StringMap<Dynamic>> {
        /*
        #if cpp
            untyped __cpp__('Result<double> result = TDialog::div(x, y)');
            return cpp.CatchException.getResult();
        #else
        */

        if (0 == y) {
            throw "division by zero";
        }
        var result = new Array<StringMap<Dynamic>>();
        var row = new StringMap<Dynamic>();
        row.set("div", x / y);
        result.push(row);

        row = new StringMap<Dynamic>();
        row.set("div", x / y);
        result.push(row);
        return result;
    
    }
}
