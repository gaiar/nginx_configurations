cd ~/ffmpeg_sources &&
	git -C aom pull 2>/dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom &&
	mkdir -p aom_build &&
	cd aom_build &&
	PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" \
		-DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
        -DAOM_TARGET_CPU=armv7 \
		-DENABLE_SHARED=on \
		-DENABLE_NASM=on ../aom &&
	PATH="$HOME/bin:$PATH" make -j $(nproc) &&
	make install
