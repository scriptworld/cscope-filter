# Cscope filter which can improve searching time while using cscope for Linux Kernel
# Author : Ji-Hun Kim (jihuun.k@gmail.com)
# Version : v0.0.1

#! /bin/bash

# Write your cross compiling tool path
GCC_PATH=
ARCHTECTURE=arm
FILTER_CONF=$CUR_PATH/.config

OPTION=$1
CUR_PATH=$(pwd -P)

make_build_log() {
	make clean
	echo "Extracting build log.. Please wait few minutes..."
	make ARCH=$ARCHTECTURE CROSS_COMPILE=$GCC_PATH -j16 > cscope_filtered.log
	echo "Done, cscope_filtered.log is extracted."
}

make_filtering() {
	awk '/\.o/ {print $2}' cscope_filtered.log |\
		sed -e "s:^:$CUR_PATH\/:" |\
		sed -e 's/\.o/\.c/g' > cscope_filtered.files
}

make_cscope() {
	case $OPTION in
		-a)
			echo "Starting to make ordinary cscope"
			find $CUR_PATH \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.s' -o -name '*.S' -o -name '*.dts' -o -name '*.dtsi' \) -print > cscope.files
			cscope -i cscope.files
			;;
		-f)
			echo "Starting to make filtered cscope"
			make_build_log
			make_filtering
			cscope -i cscope_filtered.files
			;;
		-r)
			echo "Recovering to ordinary cscope"
			cscope -i cscope.files
			;;
		--help | *)
			echo "[cscope-filter] can improve your life time while using Cscope"
			echo " Option List"
			echo "  -a			Making ordinary cscope"
			echo "  -f			Making filtered cscope"
			echo "  -r			Recovering ordinary cscope"
			echo "  --help		Printing option list"
			;;
	esac
}

make_cscope
