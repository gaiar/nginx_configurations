sudo apt-get install libomxil-bellagio-dev &&
	cd ~/ffmpeg_sources &&
	wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 &&
	tar xjvf ffmpeg-snapshot.tar.bz2 &&
	cd ffmpeg &&
	auto-apt run ./configure \
		--extra-cflags="-march=native -mtune=native" \
		--extra-libs="-lpthread -lm" \
        --enable-shared \
        --enable-pic \
		--enable-gpl \
		--enable-hardcoded-tables \
		--enable-libass \
		--enable-libfdk-aac \
		--enable-libfreetype \
		--enable-libmp3lame \
		--enable-libopus \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libx264 \
        --enable-mmal \
		--enable-omx \
		--enable-omx-rpi \
		--enable-nonfree &&
	make -j $(nproc) &&
	sudo checkinstall --default &&
	hash -r
    sudo ldconfig
