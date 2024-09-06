#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: test.sh version"
    echo "    example: test.sh  1.0.0"
    exit 1
fi

echo "Build ratel-server ======================= aa $0 aa $1 aa $# aa"