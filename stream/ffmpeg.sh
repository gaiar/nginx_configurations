sudo apt-get install libomxil-bellagio-dev &&
	cd ~/ffmpeg_sources &&
	wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 &&
	tar xjvf ffmpeg-snapshot.tar.bz2 &&
	cd ffmpeg &&
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--pkg-config-flags="--static" \
		--extra-cflags="-I$HOME/ffmpeg_build/include -march=native -mtune=native" \
		--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
		--extra-libs="-lpthread -lm" \
		--bindir="$HOME/bin" \
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
	PATH="$HOME/bin:$PATH" make -j $(nproc) &&
	make install &&
	hash -r
