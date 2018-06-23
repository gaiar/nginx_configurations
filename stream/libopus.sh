cd ~/ffmpeg_sources &&
	git -C opus pull 2>/dev/null || git clone --depth 1 https://github.com/xiph/opus.git &&
	cd opus &&
	./autogen.sh &&
	./configure \
		--prefix="$HOME/ffmpeg_build" \
		--enable-shared &&
	make -j $(nproc) &&
	make install
