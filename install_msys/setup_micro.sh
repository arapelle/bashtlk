#!/bin/bash

export GOROOT=$MINGW_PREFIX/lib/go
git clone https://github.com/zyedidia/micro && cd micro && make build && cp ./micro.exe	$MINGW_PREFIX/bin
rm -rf ~/micro
