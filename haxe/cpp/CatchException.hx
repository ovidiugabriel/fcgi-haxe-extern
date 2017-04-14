
package cpp;

// This class is C++ specific

class CatchException {
    /**
        Acts as a simple C++ macro to return the result or throw an exception message.

        The caller must have a value variable named 'result' in its scope.
        Pointer is not accepted.
     **/
    @:extern
    public static inline function getResult() {
        if (untyped __cpp__('result.isException()')) {
            throw cast(untyped __cpp__('result.getMessage()'), String);
        }
        return untyped __cpp__('result.getResult()');
    }
}
