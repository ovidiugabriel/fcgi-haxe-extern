

/**
 * Recommended presentation: https://www.youtube.com/watch?v=k2rw7-uL6RU
 */
@:buildXml("
    <files id='haxe'>
        <compilerflag value='-std=c++11' />
     </files>
")
@:headerCode('#include "TDialog.h"')
class Dialog {
    public function new() {}

    public function div( x : Float, y : Float ) : Float {
        untyped __cpp__('Result<double> result = TDialog::div(x, y)');
        return CatchException.getResult();
    }
}
