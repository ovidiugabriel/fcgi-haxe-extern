
class Dialog {
    static function display(v) {
        trace(v);
    }

    static function onError(errstr) {
        #if js
            untyped __js__("throw errstr");
        #end
    }

    static public function div( x : Float, y : Float ) : Void {
        trace('Dialog.div x=', x, ' y=', y);
        Client.call('Dialog', 'div', [x, y], display, onError);
    }

}
