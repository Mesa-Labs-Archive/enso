#!/system/bin/sh
#
# OnTheOne ensō
# Coded by BlackMesa123 @2019
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## Fields
LOGFILE="/dev/null";
BUSYBOX="/system/xbin/busybox";
IsSupported=false;
IsDream2=false;


## Functions
function enso_abort() {
    echo "" >> "$LOGFILE";
    exit 1;
}

function enso_checksupport() {
    if ! $IsSupported; then
        echo "E: enso_checksupport: Device not recognized! Aborting..." >> "$LOGFILE";
        enso_abort;
    fi;
    if $IsDream2; then
        echo "I: enso_checksupport: Device recognized: Galaxy S8+" >> "$LOGFILE";
    fi;
}

function enso_extractpkg() {
    if [ ! -f "$1" ]; then
        echo "E: enso_extractpkg: $1 not found! Aborting..." >> "$LOGFILE";
        enso_abort;
    else
        $BUSYBOX tar -xjf "$1" -C "$2" >> "$LOGFILE";
    fi;
}

function enso_initfields() {
    if [ "$(getprop ro.on.enso.debug)" = "true" ]; then
        LOGFILE="/system/on_enso.log";
    fi;
    if getprop ro.boot.bootloader | grep -iq -E -e '^G955'; then
        IsSupported=true;
        IsDream2=true;
    fi;
}

function enso_symlink() {
    if [ ! -f "$1" ]; then
        echo "E: enso_symlink: $1 not found, couldn't link to $2" >> "$LOGFILE";
        enso_abort;
    else
        if [ -f "$2" ]; then
            $BUSYBOX rm -f "$2";
        fi;
        $BUSYBOX ln -s "$1" "$2" >> "$LOGFILE";
    fi;
}


## More life
mount -o remount,rw /system;

# Init fields
enso_initfields;

echo "" >> "$LOGFILE";
echo "--- OnTheOne ensō first boot script ---" >> "$LOGFILE";
echo "-- Init. /system at" $(date '+%D %T') "--" >> "$LOGFILE";
echo "" >> "$LOGFILE";

# Check if device is compatible
enso_checksupport;

# Apply fixes
echo "I: ensō: Applying device fixes" >> "$LOGFILE";
if $IsDream2; then
    enso_extractpkg "/system/enso/dream2.onpkg" "/system";
    enso_symlink "/vendor/lib/vndk/libaudioroute.so" "/system/lib/libaudioroute.so";
    enso_symlink "/vendor/lib/vndk/libtinyalsa.so" "/system/lib/libtinyalsa.so";
    enso_symlink "/vendor/lib64/vndk/libssl.so" "/system/lib64/libssl.so";
fi;

if [ -f /system/enso/enso.prop ]; then
    echo "# ensō - device related props" >> /system/build.prop;
    $BUSYBOX cat /system/enso/enso.prop >> /system/build.prop;
fi;

# End
echo "I: ensō: All set! Script self-destroying..." >> "$LOGFILE";
rm -f /system/bin/enso.sh >> "$LOGFILE";
rm -f /system/etc/init/enso.rc >> "$LOGFILE";
rm -rf /system/enso >> "$LOGFILE";
rm -f $BUSYBOX >> "$LOGFILE";

echo "I: ensō: Rebooting..." >> "$LOGFILE";
mount -o remount,ro /system;
reboot;
