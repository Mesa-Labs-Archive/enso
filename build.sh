#!/bin/bash
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

# Define fields
ROOTDIR="$(pwd)";
OUTDIR="$ROOTDIR/out";
if [ -z "$1" ]; then
    echo "No arch defined. Using default one (arm64).";
    ARCH="arm64";
fi;
if [ "$1" = "arm" ]; then
    ARCH="arm";
fi;
if [ "$1" = "arm64" ]; then
    ARCH="arm64";
fi;
if [ -z "$ARCH" ] ; then
    echo "Unknown arch defined ($1). Using default one (arm64).";
    ARCH="arm64";
fi;

# Create necessary dirs
if [ ! -d $OUTDIR ]; then
    mkdir "$OUTDIR"
fi;
rm -rf $OUTDIR/*;

mkdir $OUTDIR/system;
mkdir $OUTDIR/system/bin;
mkdir $OUTDIR/system/enso;
mkdir $OUTDIR/system/etc;
mkdir $OUTDIR/system/etc/init;
mkdir $OUTDIR/system/xbin;

# Merge script files
python $ROOTDIR/bash_minifier/minifier.py $ROOTDIR/script/main.sh > $OUTDIR/main.sh;
echo "$(cat $OUTDIR/main.sh | base64)" > "$OUTDIR/system/enso/script";
chmod +x "$OUTDIR/system/enso/script";
rm -f $OUTDIR/main.sh;
cp -r $ROOTDIR/script/bin/. $OUTDIR/system/bin;
cp -r $ROOTDIR/script/etc/init/. $OUTDIR/system/etc/init;

if [ "$ARCH" = "arm" ]; then
    BBBIN="busybox-sel";
fi;
if [ "$ARCH" = "arm64" ]; then
    BBBIN="busybox64-sel";
fi;
cp $ROOTDIR/busybox/$BBBIN $OUTDIR/system/xbin/busybox;

cd $ROOTDIR/devicefiles;
for device in $ROOTDIR/devicefiles/*; do
    cd $device > /dev/null;
    tar -cjf $device.onpkg .;
    sed -i 's/BZh/ONPKG/g' $device.onpkg;
    cd - > /dev/null;
done;
cd "$ROOTDIR" > "/dev/null";
mv $ROOTDIR/devicefiles/*.onpkg $OUTDIR/system/enso;
