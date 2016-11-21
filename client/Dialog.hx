
class Dialog {
    static function display(v) {
        trace(v);
    }

    static public function foo( x : Float, y : Float ) : Void {
        Client.call('Dialog', 'foo', [x, y], display);
    }

}
