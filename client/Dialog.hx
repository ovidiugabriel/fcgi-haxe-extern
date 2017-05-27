
class Dialog {
    static function display(v) {
        trace(v);
    }

    static function onError(errstr) {
        trace('ERROR: $errstr');
    }

    static public function div( x : Float, y : Float ) : Void {
        Client.call('Dialog', 'div', [x, y], display, onError);
    }

}
