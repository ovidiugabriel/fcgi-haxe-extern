#!/bin/bash

set -x

export FCGI_HAXE_EXTERN_PATH=`dirname $(cygpath $PWD)`
export HXCPP_MINGW=1

if [ "" == "$FCGI_HAXE_EXTERN_PATH" ] ; then
    echo "FCGI_HAXE_EXTERN_PATH is not set"
    exit 1
fi

haxe -main Main Client NativeClient HttpAsyncConnection -D HXCPP_M32 -D HXCPP_STACK_TRACE -D HXCPP_STACK_LINE -cpp output/Client
# -D static_link
