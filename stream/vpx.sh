cd ~/ffmpeg_sources &&
	git -C libvpx pull 2>/dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git &&
	cd libvpx &&
	PATH="$HOME/bin:$PATH" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--enable-shared \
		--disable-examples \
		--disable-unit-tests \
		--enable-vp9-highbitdepth \
		--as=yasm &&
	PATH="$HOME/bin:$PATH" make -j $(nproc) &&
	make install
