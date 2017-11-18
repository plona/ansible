#!/bin/bash - 
#===============================================================================
#
#          FILE: pre-install.sh
# 
#         USAGE: ./pre-install.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: NASK
#       CREATED: 11/17/2017 09:07:20 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit

files="files"

rm -rf $files/home/.vim || true
cp -Rp $HOME/.vim $files/home

mkdir -p $files/etc/bash_completion.d || true
cp /etc/tmux.conf $files/etc
cp /etc/bash_completion.d/tmux $files/etc/bash_completion.d

shopt -s dotglob

pushd $files/home
tar czf ../home.tgz *
popd

pushd $files/etc
tar czf ../etc.tgz *
popd

shopt -u dotglob

rm -f log/* || true

exit 0
