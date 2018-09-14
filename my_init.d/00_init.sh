#!/bin/bash
set -e

/etc/rc5.d/S02dbus start
console-kit-daemon 
xinetd &
lightdm &
