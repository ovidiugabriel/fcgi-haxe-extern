
class Dialog {
    static function display(v) {
        Logging.getConsole().log(v);
    }

    static function onError(errstr : String) {
        throw errstr;
    }

    static public function div( x : Float, y : Float ) : Void {
        Logging.getConsole().log('Dialog.div x=', x, ' y=', y);
        Client.call('Dialog', 'div', [x, y], display, onError);
    }
}
