#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s ${BASEDIR}/vimrc ~/.vimrc
ln -s ${BASEDIR}/vim ~/.vim
