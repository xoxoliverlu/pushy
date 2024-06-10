#!/bin/dash

if [ -d ".pushy" ]
then
    echo "./pushy-init: error: .pushy already exists"
    exit 1
fi

mkdir ".pushy" && echo "Initialized empty pushy repository in .pushy"
