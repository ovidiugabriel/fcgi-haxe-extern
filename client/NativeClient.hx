
import haxe.ds.StringMap;

typedef OnEachRowFunction = Int -> Array<String> -> Void;

class NativeClient {
    // Native C++ callbacks
    static public var onEachRow : cpp.Function<OnEachRowFunction, cpp.abi.Abi>;
    static public var onDone : cpp.Function<Void -> Void, cpp.abi.Abi> ;
    static public var onError : cpp.Function<String -> Void, cpp.abi.Abi>;

    // You may want to supply 'callOnSuccess' and/or 'callOnError'
    // to Client.call(), to get native handlers called.

    static public function callOnSuccess( result : Array<Array<String>> ) : Void {
        if (null == onEachRow) {
            return;
        }

        trace(result);

        if (result.length > 0) {
            // first row always contains headers
            trace(result[0]);
            onEachRow.call(-1, result[0]);
        }

        var i:Int = 1;
        for (i in 1...result.length) {
            trace(result[i]);
            onEachRow.call(i-1, result[i]);
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
