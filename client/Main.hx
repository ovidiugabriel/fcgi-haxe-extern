
@:buildXml("
<files id='haxe'>
    <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
</files>
<files id='__main__'>
    <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
</files>
")
@:headerCode('#include "TMain.h"')
class Main {
    static function main() : Void {
        untyped __cpp__('TMain_main()');
    }
}
