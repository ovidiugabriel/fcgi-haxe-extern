
@:buildXml("
     <files id='haxe'>
        <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
     </files>
     <files id='__main__'>
        <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
     </files>
")
@:headerCode('#include "TMain.h"')
//.// @:headerCode('#include "TClient.h"')
class Main {
	static function main() : Void {
		var x = 1;
		//Client.onSuccess = untyped __cpp__('TClient_display');
		untyped __cpp__('TMain_main()');
	}

	// static public function display(v : Float) : Void {
 //        // untyped __cpp__('TClient_display(v)');
 //    }

 //    static public function onError( errstr : String ) : Void {
 //        // untyped __cpp__('TClient_onError(errstr)');        
 //    }
}