#!/bin/bash -ev

mkdir -p ~/.ticocoin
echo "rpcuser=username" >>~/.ticocoin/ticocoin.conf
echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.ticocoin/ticocoin.conf

