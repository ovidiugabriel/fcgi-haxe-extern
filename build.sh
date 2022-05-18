#!/bin/bash -x

# - build the server
# - deploy the server
# - test the server code in command line

# - build the JavaScript client
# - deploy the JavaScript client
#
# Build the server
#

export FCGI_HAXE_EXTERN_PATH=`cygpath -w $PWD`
export HXCPP_MINGW=1
# export MINGW_ROOT="/cygdrive/c/Qt/Tools/mingw530_32"

# Cleanup old server files
if [ "1" == "$CLEAN" ] ; then
    rm -rf Server
fi

cd haxe
haxe build.hxml
if [ "$?" != "0" ] ; then
    exit 1
fi
cd ..

# :: building the executable file
# pushd "test/Server"
# qmake -d 2> qmake.log
# if [ "1" == "$CLEAN" ] ; then
#     mingw32-make clean
# fi
# mingw32-make
# popd

#
# Deploy the server
#

# :: copy the executable to the cgi-bin folder

XAMPP_PATH=$(cygpath "C:\xampp")
CGI_BIN_PATH=$XAMPP_PATH/cgi-bin
CGI_SERVER_EXE=$CGI_BIN_PATH/Server.exe

if [ -e $CGI_SERVER_EXE ] ; then
    rm $CGI_SERVER_EXE
fi

SERVER=$PWD/Server/Server.exe
if [ -e $SERVER ] ; then
    cp $SERVER                        $CGI_BIN_PATH

    # TODO: detect dependencies
    # copy dependencies
    cp $PWD/Server/libgcc_s_dw2-1.dll $CGI_BIN_PATH
    cp $PWD/Server/libstdc++-6.dll    $CGI_BIN_PATH
else
    echo "Server $SERVER not built"
    exit 1
fi

#
# Building JavaScript client
#

pushd client
haxe -main Main Client -debug -js js/Client.js
if [ "$?" != "0" ] ; then
    exit 1
fi
popd

# "//# sourceMappingURL=http://example.com/path/to/your/sourcemap.map"

#
# Deploy the JavaScript client
#

#  Copying client JavaScript files
HTDOCS=$XAMPP_PATH/htdocs
mkdir -p $HTDOCS/fcgi-client

cp $PWD/client/test.html $HTDOCS/fcgi-client
cp $PWD/client/.htaccess $HTDOCS/fcgi-client

JSDIR=$HTDOCS/fcgi-client/js
if [ ! -d $JSDIR ] ; then
    mkdir $JSDIR
fi

# copy javascript and source map file
cp $PWD/client/js/Client.js $JSDIR
cp $PWD/client/js/Client.js.map $JSDIR
