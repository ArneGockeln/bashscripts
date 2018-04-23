#!/bin/bash
# This script routes the spotify traffic through the wifi interface

echo "Add the Google Plugin DNS Server to your Wi-Fi interface!!"
echo "8.8.8.8"
echo "8.8.4.4"

target_device="Wi-Fi"
interface=`networksetup -listnetworkserviceorder | \
grep "Hardware Port: $target_device" | \
grep -o -E "en\\d"`

if [ -z "$interface" ]; then
	echo "No interface for \"$target_device\" was found."
	exit 1
else
	for ip in "78.31.8.0/24" "78.31.12.0/24" "193.182.8.0/24" "193.235.0.0/16" "193.182.0.0/16" "194.68.0.0/16" "193.235.232.103" "194.132.198.149" "194.132.196.228" "194.132.196.226" "194.132.197.198"; do
		sudo route delete $ip 2&>1 >/dev/null
		sudo route -n add $ip -interface $interface >/dev/null
	done
	exit 0
fi
