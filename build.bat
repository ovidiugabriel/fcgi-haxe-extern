:: Need to have MSVC installed and run this script from command line
:: Tested in cygwin also
:: rem set PATH=%PATH%;C:\HaxeToolkit\neko

@echo off
for /f %%i in ('cygpath -w %PWD%') do set FCGI_HAXE_EXTERN_PATH=%%i
set HXCPP_MINGW=1
set MINGW_ROOT=C:\Qt\Tools\mingw530_32

:: rm -rf Server

cd haxe
haxe build.hxml
cd ..

:: building the executable file
cd test/Server
qmake
:: mingw32-make clean
mingw32-make
cd ../..

:: copy the executable to the cgi-bin folder
rm  c:\xampp\cgi-bin\Server.exe
copy test\Server\debug\Server.exe c:\xampp\cgi-bin

:: simply execute the binary in the console to check for the output
:: export PATH_INFO="/Dialog"
test\Server\debug\Server.exe

cd client
call build.bat
cd ..

for /f %%i in ('bash -c "cygpath -w `realpath client/test.html `"') do set TEST_HTML=%%i

set FIREFOX="C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
%FIREFOX% %TEST_HTML%
