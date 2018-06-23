cd ~/ffmpeg_sources &&
	wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz &&
	tar xzvf lame-3.100.tar.gz &&
	cd lame-3.100 &&
	PATH="$HOME/bin:$PATH" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--bindir="$HOME/bin" \
		--enable-shared \
		--enable-nasm &&
	PATH="$HOME/bin:$PATH" make -j $(nproc) &&
	make install
