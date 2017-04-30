
import haxe.ds.StringMap;

typedef OnEachRowFunction = Int -> Array<String> -> Void;

class NativeClient {
    // Native C++ callbacks
    static public var onEachRow : cpp.Function<OnEachRowFunction, cpp.abi.Abi>;
    static public var onDone : cpp.Function<Void -> Void, cpp.abi.Abi> ;
    static public var onError : cpp.Function<String -> Void, cpp.abi.Abi>;

    // You may want to supply 'callOnSuccess' and/or 'callOnError'
    // to Client.call(), to get native handlers called.

    static public function callOnSuccess( result : Array<StringMap<Dynamic>> ) : Void {
        if (null == onEachRow) {
            trace('onEachRow is not set');
            return;
        }

        if (result.length > 0) {
            var keys : Array<String> = new Array<String>();
            var row = result[0];
            for (key in row.keys()) {
                keys.push(key);
            }
            onEachRow.call(-1, keys);
        }

        var i : Int = 0;
        for (row in result) {
            var array : Array<String> = new Array<String>();
            for (key in row.keys()) {
                array.push(row.get(key));
            }
            onEachRow.call(i, array);
            i++;
        }

        if (null != onDone) {
            onDone.call();
        } else {
            trace('onDone is not set');
        }
    }

    static public function callOnError( errstr : String ) : Void {
        onError.call(errstr);
    }
}
