#!/bin/bash

# prepare
echo "jiang186212" | sudo apt install shadowsocks-libev
echo "jiang186212" | sudo cp shadowsocks.json /etc
echo "jiang186212" | sudo cp sslocal.service /etc/systemd/system/

# enable and start service
echo "jiang186212" | sudo systemctl enable sslocal
echo "jiang186212" | sudo systemctl restart sslocal

# config git use socks5 proxy
echo "jiang186212" | sudo apt install git
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'

# config proxychains use socks5
echo "jiang186212" | sudo apt install proxychains
echo "jiang186212" | sudo cp proxychains.conf /etc/
