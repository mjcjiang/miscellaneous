#!/bin/bash

replace_software_source() {
    password=$1
    dist=$2
    source_file=$3

    echo ${password} | sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    echo ${password} | sudo cp ${source_file} /etc/apt/sources.list
    echo "${dist} software resource change finish..."
    echo ${password} | sudo apt update
}

dist=$(lsb_release -a 2>/dev/null | grep Distributor | cut -d':' -f 2 | awk '{$1=$1};1')
if [[ "${dist}" == "Raspbian" ]]; then
    replace_software_source "jiang186212" ${dist} raspbian_qsinghua.txt
elif [[ "${dist}" == "Linuxmint" ]]; then
    replace_software_source "jiang186212" ${dist} linuxmint_qsinghua.txt
elif [[ "${dist}" == "Ubuntu" ]]; then
    replace_software_source "jiang186212" ${dist} linuxmint_qsinghua.txt
fi
