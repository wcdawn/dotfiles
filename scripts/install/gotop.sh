#!/bin/bash

VERSION='1.14.2'
OS='linux'
ARCH='amd64'

GO_NAME=go${VERSION}.${OS}-${ARCH}

mkdir -p $HOME/pkg
cd $HOME/pkg

curl https://dl.google.com/go/${GO_NAME}.tar.gz --output ./${GO_NAME}.tar.gz

tar -vxzf ${GO_NAME}.tar.gz
rm ${GO_NAME}.tar.gz

PATH=$HOME/pkg/go/bin:$PATH

git clone https://github.com/xxxserxxx/gotop.git
cd ./gotop
go build -o gotop ./cmd/gotop

ln -sf ./gotop $HOME/bin/gotop

rm -rf $HOME/pkg/go
