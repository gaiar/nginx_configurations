cd ~/ffmpeg_sources &&
	wget https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2 &&
	tar xjvf nasm-2.13.03.tar.bz2 &&
	cd nasm-2.13.03 &&
	./autogen.sh &&
	PATH="$HOME/bin:$PATH" CFLAGS="-Wno-error" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--bindir="$HOME/bin" &&
	make -j $(nproc) &&
	make install
