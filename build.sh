#!/bin/bash -x

#
# :: Need to have MSVC installed and run this script from command line
# :: Tested in cygwin also
#

# PATH=$(printf "%q" "$PATH")
export FCGI_HAXE_EXTERN_PATH=`cygpath -w $PWD`
export HXCPP_MINGW=1
export MINGW_ROOT="/cygdrive/c/Qt/Tools/mingw530_32"

# Cleanup old server files
if [ "1" == "$CLEAN" ] ; then
    rm -rf Server
fi

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
SERVER_EXE="/cygdrive/c/xampp/cgi-bin/Server.exe"
if [ -e $SERVER_EXE ] ; then
    rm $SERVER_EXE
fi
SERVER="./test/Server/debug/Server.exe"
if [ -e $SERVER ] ; then
    cp $SERVER /cygdrive/c/xampp/cgi-bin
else
    echo "Server $SERVER not built"
    exit 1
fi

# :: simply execute the binary in the console to check for the output
export PATH_INFO="/Dialog"
$SERVER

# Building client project
pushd client
haxe -main Client -debug -js js/Client.js
popd

# "//# sourceMappingURL=http://example.com/path/to/your/sourcemap.map"

#  Copying client JavaScript files
HTDOCS="/cygdrive/c/xampp/htdocs"
cp ./client/test.html $HTDOCS
cp ./client/.htaccess $HTDOCS

JSDIR="/cygdrive/c/xampp/htdocs/js"
if [ ! -d $JSDIR ] ; then
    mkdir $JSDIR
fi
cp ./client/js/Client.js $JSDIR

# Running client test in browser
firefox http://localhost/test.html

