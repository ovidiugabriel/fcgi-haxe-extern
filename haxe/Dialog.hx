

/*
 * Recommended presentation: https://www.youtube.com/watch?v=k2rw7-uL6RU
 */

#if cpp
// Available only with a C++11 compiler
/*
@:buildXml("
    <files id='haxe'>
        <compilerflag value='-std=c++11' />
     </files>
")
*/
@:headerCode('#include "TDialog.h"')
#end
class Dialog {
    public function new() {}

    public function div( x : Float, y : Float ) : Float {
        #if cpp
            untyped __cpp__('Result<double> result = TDialog::div(x, y)');
            return cpp.CatchException.getResult();
        #else
            return x / y;
        #end
    }
}
