#!/bin/bash

#
# :: Need to have MSVC installed and run this script from command line
# :: Tested in cygwin also
#

PATH=$(printf "%q" "$PATH")
export FCGI_HAXE_EXTERN_PATH=`cygpath -w $PWD`
export HXCPP_MINGW=1
export MINGW_ROOT="/cygdrive/c/Qt/Tools/mingw530_32"
# QMAKE=/cygdrive/c/Qt/5.7/mingw53_32/bin/qmake.exe

set -o verbose

# Cleanup old server files
rm -rf Server

cd haxe
haxe build.hxml
cd ..

# :: building the executable file
pushd "test/Server"
qmake -d 2> qmake.log
mingw32-make clean
mingw32-make
popd

# :: copy the executable to the cgi-bin folder
rm /cygdrive/c/xampp/cgi-bin/Server.exe
SERVER="./test/Server/debug/Server.exe"
cp $SERVER /cygdrive/c/xampp/cgi-bin

# :: simply execute the binary in the console to check for the output
export PATH_INFO="/Dialog"
$SERVER

# Building client project
pushd client
haxe -main Client -js js/Client.js
popd

cp  ./client/test.html /cygdrive/c/xampp/htdocs
JSDIR="/cygdrive/c/xampp/htdocs/js"
if [ ! -d $JSDIR ] ; then
    mkdir $JSDIR
fi
cp ./client/js/Client.js $JSDIR
