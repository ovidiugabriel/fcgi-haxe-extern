
import haxe.PosInfos;

@:headerCode('#include "Trace.h"')
class Logging {
    static public function info(message : String, ?infos : PosInfos) : Void {
        Logging.trace(message, infos);
    }

    static private function trace(message : String, ?infos : PosInfos) : Void {
        logMessage(untyped message.c_str());
    }

    @:extern @:native('::logMessage')
    static private function logMessage(message : String);
}
