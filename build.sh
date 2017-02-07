 #
 # Copyright © 2016, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
 # Copyright © 2016, Ashish Malik "AshishM94" <im.ashish994@gmail.com>
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
ZIP_DIR=$KERNEL_DIR/AnyKernel2
KERN_IMG=$KERNEL_DIR/arch/arm/boot/zImage
DT_IMG=$KERNEL_DIR/arch/arm/boot/dt.img
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
VER="Phoenix-Kernel-$(date +"%Y-%m-%d"-%H%M)-"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/bale/android/toolchains/arm-eabi-4.8/bin/arm-eabi-"
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="bale"
export KBUILD_BUILD_HOST="K46CB-Inc."
make phoenix_defconfig
make -j3

$DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
echo -e "$blue***********************************************"
echo "          creating flashable zip          "
echo -e "***********************************************$nocol"
cd $ZIP_DIR
cp $DT_IMG $ZIP_DIR/dtb
cp $KERN_IMG $ZIP_DIR
zip -r $VER.zip *
cd $KERNEL_DIR
rm -f $DT_IMG
make clean && make mrproper

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
