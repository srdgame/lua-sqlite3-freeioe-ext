#!/usr/bin/env bash

if [ $# -lt 1 ] ; then
	echo "Usage: build_ext_all.sh <target dir>"
	exit 0
fi

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

TARGET_PATH=$1
CUR_DIR=`pwd`

declare -A plats

plats["linux/x86_64"]="native"
#plats["openwrt/arm_cortex-a9_neon"]="imx6_exports.sh"
plats["openwrt/17.01/arm_cortex-a9_neon"]="tg3030_exports.sh"
plats["openwrt/18.06/mips_24kc"]="mips_24kc.sh"
plats["openwrt/18.06/x86_64"]="x86_64_glibc.sh"
#plats["openwrt/aarch64_cortex-a53"]="bp3plus_exports.sh"
plats["openwrt/19.07/arm_cortex-a7_neon-vfpv4"]="sunxi_a7.sh"
plats["openwrt/19.07/x86_64"]="x86_64_glibc_19.07.sh"
# plats["android/arm"]="android_arm.sh"

for item in "${!plats[@]}"; 
do
	mkdir -p ${TARGET_PATH}/${item}/sqlite3
	mkdir -p ${TARGET_PATH}/${item}/sqlite3/luaclib/sqlite3
	mkdir -p ${TARGET_PATH}/${item}/sqlite3/lualib

	rm build -rf
	rm bin -rf

	premake5 gmake
	if [ "${plats[$item]}" == "native" ]; then
		unset CC
		unset CXX
		unset AR
		unset STRIP
	else
		. ~/toolchains/${plats[$item]}
	fi

	cd build
	make config=release
	cd ..
	cp -f bin/Release/sqlite3/core.so $TARGET_PATH/${item}/sqlite3/luaclib/sqlite3
	cp -f lua-sqlite3/sqlite3.lua $TARGET_PATH/${item}/sqlite3/lualib
done
