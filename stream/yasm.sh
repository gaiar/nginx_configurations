cd ~/ffmpeg_sources &&
	wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz &&
	tar xzvf yasm-1.3.0.tar.gz &&
	cd yasm-1.3.0 &&
	./configure \
	--prefix="$HOME/ffmpeg_build" \
	--bindir="$HOME/bin" &&
	make -j $(nproc) &&
	make install
