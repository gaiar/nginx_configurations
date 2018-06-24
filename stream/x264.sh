cd ~/ffmpeg_sources &&
	wget -O last_x264.tar.bz2 ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 &&
	mkdir -p x264 &&
	tar xjvf last_x264.tar.bz2 -C x264 &&
	cd x264/x264* &&
	auto-apt run ./configure \
		--enable-shared \
		--enable-pic &&
	make -j $(nproc) &&
	sudo checkinstall --default
