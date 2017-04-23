set HXCPP_MINGW=1
haxe -main Main Client NativeClient -D HXCPP_M32 -D HXCPP_STACK_TRACE -D HXCPP_STACK_LINE -cpp output/Client
:: -D static_link 
pause