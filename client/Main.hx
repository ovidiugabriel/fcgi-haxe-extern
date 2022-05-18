
#if cpp
    @:buildXml("
        <files id='haxe'>
            <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
        </files>
        <files id='__main__'>
            <compilerflag value='-I${FCGI_HAXE_EXTERN_PATH}/client/cpp' />
        </files>
    ")
#end

#if cpp
    @:headerCode('#include "TMain.h"')
#end
class Main {
    /**
        The entry point for all Haxe Remoting clients (both JavaScript and C++)
    **/
    static function main() : Void {
        #if cpp
            untyped __cpp__('TMain_main()');
        #elseif js
            haxe.Log.trace = untyped console.log.bind(console.log);

            // We need to know the endpoint URL
            Client.setURL("http://localhost/cgi-bin/Server.exe");
            Dialog.div(1, 2);
            Dialog.div(1, 0);
        #end
    }
}
