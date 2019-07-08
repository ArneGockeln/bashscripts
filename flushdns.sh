#!/bin/bash
# Flush DNS Cache of Mojave
# 
sudo killall -HUP mDNSResponder;
sudo killall mDNSResponderHelper;
sudo dscacheutil -flushcache
echo "Done."