:: Need to have MSVC installed and run this script from command line
:: Tested in cygwin also
:: rem set PATH=%PATH%;C:\HaxeToolkit\neko

@echo off
for /f %%i in ('cygpath -w %PWD%') do set FCGI_HAXE_EXTERN_PATH=%%i
set HXCPP_MINGW=1
set MINGW_ROOT=C:\Qt\Tools\mingw530_32

cd haxe
haxe build.hxml
cd ..
