#!/bin/bash - 
#===============================================================================
#
#          FILE: 01-backup-configuration.sh
# 
#         USAGE: ./01-backup-configuration.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: NASK
#       CREATED: 11/22/2017 11:50:17 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit
#set -x

# sprawdzenie "zatrzymanych" pakietów
hold=false
#aptitude search "~ahold"
dpkg --get-selections | grep 'hold$' || true
#[[ $(aptitude search "~ahold" | wc -l) -eq 0 ]] || hold=true
[[ $(dpkg --get-selections | grep 'hold$' | wc -l) -eq 0 ]] || hold=true
[[ $hold == true ]] && {
    echo "some packages is marked as 'holded'"
    exit 1
}

# katalog na backup
bck_dir="/var/tmp/upgrade.bck"
[[ -d "$bck_dir" ]] || mkdir "$bck_dir"

# katalogi do backupu
declare -A bck_dirs
bck_dirs['etc']='/'
bck_dirs['dpkg']='/var/lib'
bck_dirs['extended_states']='/var/lib/apt'
bck_dirs['pkgstates']='/var/lib/aptitude'

# backup plików i katalogów
for key in "${!bck_dirs[@]}"
do
  f="${bck_dirs[$key]}/$key"
  abs_path=$(readlink -e $f || true)
  [[ -z "$abs_path" ]] && {
    echo -e "non-existing file/dir: $f\nskipping ..." 
  } || {
    #cmd="tar --ignore-failed-read --create --compress --file=\"$bck_dir/$key.tgz\" -C \"${bck_dirs[$key]}\" \"$key\""
    cmd="tar --ignore-failed-read --create --file=\"$bck_dir/$key.tar\" \"$f\""
    echo $cmd
    eval "$cmd"
  }
done

# zainstalowanie pakiety
cmd="dpkg --get-selections \"*\" > $bck_dir/dpkg.txt"
echo $cmd
eval "$cmd"

exit 0
