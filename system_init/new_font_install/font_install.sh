#!/bin/bash

if [ ! -d "${HOME}/.fonts/" ]; then
    echo "${HOME}/.fonts not exist, Just creating..."
    mkdir "${HOME}/.fonts"
    echo "${HOME}/.fonts created..."
fi

echo "jiang186212" | sudo cp *.ttf ~/.fonts/
echo "jiang186212" | sudo fc-cache -fv
