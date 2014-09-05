#! /bin/sh

# remove old modules
#rm -rf ./modules/*

# compile the kernel
cd kernel
make kexec_quincyatt_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j9
#make INSTALL_MOD_PATH=../modules modules_install
cd ..

# compile the backports
#cd backports
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- KLIB_BUILD=../kernel KLIB=../modules defconfig-brcmfmac
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- KLIB_BUILD=../kernel KLIB=../modules
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- KLIB_BUILD=../kernel KLIB=../modules install
#cd ..

# build the ramdisk
cd ramdisk
find . -print | cpio -H newc -o | gzip -9 > ../ramdisk.cpio.gz
cd ..

# make the boot image
mkbootimg --kernel kernel/arch/arm/boot/zImage --ramdisk ramdisk.cpio.gz --base 0x48000000 --ramdiskaddr 0x49600000 --cmdline 'androidboot.hardware=qcom usb_id_pin_rework=true zcache' -o new_boot.img

# copy the boot image into the zip root
mv new_boot.img kernel-zip/boot.img

# create the zip
cd kernel-zip
zip -r ../kernel_kexecboot.zip *
