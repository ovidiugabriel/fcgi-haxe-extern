:: Need to have MSVC installed and run this script from command line
:: Tested in cygwin also
:: rem set PATH=%PATH%;C:\HaxeToolkit\neko

set HXCPP_MINGW=1
set MINGW_ROOT=C:\Qt\Tools\mingw530_32

IF EXIST Server\src\cpp GOTO ALREADYEXISTS
mkdir Server\src\cpp
:ALREADYEXISTS

copy cpp\Web.h Server\src\cpp
cd haxe
haxe build.hxml
cd ..
copy Server\Server.exe C:\xampp\cgi-bin
Server\Server.exe

