#! /bin/bash

SET_DIR=/usr/local/bin
CUR_DIR=$(pwd -P)

sudo ln -s $CUR_DIR/cscope-filter.sh $SET_DIR/cscope-filter
