cd ~/ffmpeg_sources &&
	git -C x264 pull 2>/dev/null || git clone --depth 1 https://git.videolan.org/git/x264 &&
	cd x264 &&
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--bindir="$HOME/bin" \
		--enable-shared \
		--enable-pic &&
	PATH="$HOME/bin:$PATH" make -j $(nproc) &&
	make install
