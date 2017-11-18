#!/bin/bash - 
#===============================================================================
#
#          FILE: net_interface.sh
# 
#         USAGE: ./net_interface.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: NASK
#       CREATED: 11/17/2017 01:13:05 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

template=$1
new_if=$2

subnet="10.243.19"
gw="$subnet.1"
dns_ns="172.19.243.1"
dns_search="dro.nask.pl"

tmp=$(ip addres show $template | grep -w inet | awk '{print $2}')
tmp="${tmp%/*}"
if_part="${tmp##*.}"

echo
echo "# added by ansible"
echo "allow-hotplug ens4"
echo "iface $new_if inet static
    address $subnet.$if_part/24
    gateway $gw
    dns-nameservers $dns_ns
    dns-search $dns_search
"

exit 0
