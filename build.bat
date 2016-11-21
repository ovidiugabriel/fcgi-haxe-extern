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

:: building the executable file
cd test/Server
qmake
mingw32-make
cd ../..

:: copy the executable to the cgi-bin folder
for /f %%i in ('bash -c "ls -1 test | grep build"') do set BUILD_FOLDER=%%i
copy test\%BUILD_FOLDER%\debug\Server.exe c:\xampp\cgi-bin

:: simply execute the binary in the console to check for the output
test\%BUILD_FOLDER%\debug\Server.exe

set FIREFOX="C:\Program Files (x86)\Mozilla Firefox\firefox.exe"

%FIREFOX% http://localhost/cgi-bin/Server.exe