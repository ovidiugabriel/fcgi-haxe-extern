:: Hardcoded
set FCGI_HAXE_EXTERN_PATH=c:\xampp\htdocs\fcgi-haxe-extern
set HXCPP_MINGW=1
if "" == "%FCGI_HAXE_EXTERN_PATH%" (
  echo FCGI_HAXE_EXTERN_PATH is not set
  goto exit
)
del output\Client\include\Main.h
haxe -main Main Client NativeClient -D HXCPP_M32 -D HXCPP_STACK_TRACE -D HXCPP_STACK_LINE -cpp output/Client
:: -D static_link 
pause
:exit