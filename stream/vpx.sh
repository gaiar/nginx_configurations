cd ~/ffmpeg_sources &&
	wget -O libvpx-1.7.0.tar.gz https://chromium.googlesource.com/webm/libvpx/+archive/f80be22a1099b2a431c2796f529bb261064ec6b4.tar.gz &&
	mkdir -p libvpx &&
	tar xvfz libvpx-1.7.0.tar.gz -C libvpx &&
	cd libvpx &&
	auto-apt run ./configure \
		--enable-shared \
		--disable-examples \
		--disable-unit-tests \
		--enable-vp9-highbitdepth \
		--as=yasm &&
	make -j $(nproc) &&
	sudo checkinstall --default --pkgversion="1.7.0" -y
