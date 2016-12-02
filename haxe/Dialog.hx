

/**
 * Recommended presentation: https://www.youtube.com/watch?v=k2rw7-uL6RU
 */
@:headerCode('#include "TDialog.h"')
class Dialog {
    public function new() {}

    public function foo( x : Float, y : Float ) : Float {
        return untyped __cpp__('TDialog::foo(x, y)');
    }
}
