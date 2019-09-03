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

# Debug
LOGFILE="/dev/null"

# Device
IsSupported=false
IsDream2=false

if [ "$(getprop ro.on.enso.debug)" = "true" ]; then
    LOGFILE="/system/on_enso.log"
fi

if getprop ro.boot.bootloader | grep -iq -E -e '^G955'; then
    IsSupported=true
    IsDream2=true
fi

# More life
mount -o remount,rw /system

echo "" >> $LOGFILE
echo "--- OnTheOne ensō first boot script ---" >> $LOGFILE
echo "" >> $LOGFILE

if ! $IsSupported; then
    echo "E: Device not recognized! Aborting..." >> $LOGFILE
    echo "" >> $LOGFILE
    exit 1
fi
if $IsDream2; then
    echo "I: Device recognized: Galaxy S8+" >> $LOGFILE
fi

echo "" >> $LOGFILE

# Install busybox
echo " - Installing BusyBox in /system/xbin" >> $LOGFILE
/system/xbin/busybox --install -s /system/xbin >> $LOGFILE

if [ ! -f /system/xbin/tar ]; then
    echo "" >> $LOGFILE
    echo "E: BusyBox install failed! Aborting..." >> $LOGFILE
    echo "" >> $LOGFILE
    exit 1
fi

# Apply fixes
echo " - Applying device fixes" >> $LOGFILE
if $IsDream2; then
    /system/xbin/tar -xjf /system/enso/dream2.onpkg -C /system >> $LOGFILE
    /system/xbin/ln -s /vendor/lib/vndk/libaudioroute.so /system/lib/libaudioroute.so >> $LOGFILE
    /system/xbin/ln -s /vendor/lib/vndk/libtinyalsa.so /system/lib/libtinyalsa.so >> $LOGFILE
fi

# End
echo "" >> $LOGFILE
echo "I: All set! Deleting ensō..." >> $LOGFILE
rm -f /system/etc/init/enso.rc >> $LOGFILE
rm -f /system/bin/enso.sh >> $LOGFILE
rm -rf /system/enso >> $LOGFILE

echo "I: Rebooting..." >> $LOGFILE
mount -o remount,ro /system
reboot
