#!/bin/bash

#
#  This is the new GCC version to install.
#
VERSION=8.1.0

#
#  For the Pi or any computer with less than 2GB of memory.
#
if [ -f /etc/dphys-swapfile ]; then
	sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile stop
	sudo /etc/init.d/dphys-swapfile start
fi

if [ -d gcc-$VERSION ]; then
	cd gcc-$VERSION
	rm -rf obj
else
	wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.xz
	tar xf gcc-$VERSION.tar.xz
	cd gcc-$VERSION
	contrib/download_prerequisites
fi
mkdir -p obj
cd obj

#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform.  You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#

#current install
# ../src/configure -v \
# 	--with-pkgversion='Raspbian 6.3.0-18+rpi1+deb9u1' \
# 	--with-bugurl=file:///usr/share/doc/gcc-6/README.Bugs \
# 	--enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ \
# 	--prefix=/usr \
# 	--program-suffix=-6 \
# 	--program-prefix=arm-linux-gnueabihf- \
# 	--enable-shared \
# 	--enable-linker-build-id \
# 	--libexecdir=/usr/lib \
# 	--without-included-gettext \
# 	--enable-threads=posix \
# 	--libdir=/usr/lib \
# 	--enable-nls \
# 	--with-sysroot=/ \
# 	--enable-clocale=gnu \
# 	--enable-libstdcxx-debug \
# 	--enable-libstdcxx-time=yes \
# 	--with-default-libstdcxx-abi=new \
# 	--enable-gnu-unique-object \
# 	--disable-libitm \
# 	--disable-libquadmath \
# 	--enable-plugin \
# 	--with-system-zlib \
# 	--disable-browser-plugin \
# 	--enable-java-awt=gtk \
# 	--enable-gtk-cairo \
# 	--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-6-armhf/jre \
# 	--enable-java-home \
# 	--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-6-armhf \
# 	--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-6-armhf \
# 	--with-arch-directory=arm --with-ecj-jar=/usr/share/java/eclipse-ecj.jar \
# 	--with-target-system-zlib \
# 	--enable-objc-gc=auto \
# 	--enable-multiarch \
# 	--disable-sjlj-exceptions \
# 	--with-arch=armv6 \
# 	--with-fpu=vfp \
# 	--with-float=hard \
# 	--enable-checking=release \
# 	--build=arm-linux-gnueabihf \
# 	--host=arm-linux-gnueabihf \
# 	--target=arm-linux-gnueabihf

#gcc version 6.3.0 20170516 (Raspbian 6.3.0-18+rpi1+deb9u1)

# Pi3+, Pi3, and new Pi2
../configure --enable-languages=c,c++,ada,fortran \
	--with-cpu=cortex-a53 \
	--with-fpu=neon-fp-armv8 \
	--with-float=hard \
	--build=arm-linux-gnueabihf \
	--host=arm-linux-gnueabihf \
	--target=arm-linux-gnueabihf \
	--enable-checking=no

# Pi Zero's
#../configure --enable-languages=c,c++ --with-cpu=arm1176jzf-s \
#  --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

# x86_64
#../configure --disable-multilib --enable-languages=c,c++ --enable-checking=no

# Odroid-C2 AArch64
#../configure --enable-languages=c,c++ --with-cpu=cortex-a53 --enable-checking=no

# Old Pi2
#../configure --enable-languages=c,c++ --with-cpu=cortex-a7 \
#  --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-checking=no

#
#  Now build GCC which will take a long time.  This could range from
#  4.5 hours on a Pi3B+ up to about 50 hours on a Pi Zero.  It can be
#  left to complete overnight (or over the weekend for a Pi Zero :-)
#  The most likely causes of failure are lack of disk space, lack of
#  swap space or memory, or the wrong configure section uncommented.
#  The new compiler is placed in /usr/local/bin, the existing compiler remains
#  in /usr/bin and may be used by giving its version gcc-6 (say).
#
if make -j $(nproc); then
	echo
	read -p "Do you wish to install the new GCC (y/n)? " yn
	case $yn in
	[Yy]*) sudo make install ;;
	*) exit ;;
	esac
fi

#
# An alternative way of adding swap
#
#sudo dd if=/dev/zero of=/swapfile1GB bs=1G count=1
#sudo chmod 0600 /swapfile1GB
#sudo mkswap /swapfile1GB
#sudo swapon /swapfile1GB
