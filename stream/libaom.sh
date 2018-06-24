cd ~/ffmpeg_sources &&
	git -C aom pull 2>/dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom &&
	mkdir -p aom_build &&
	cd aom_build &&
	auto-apt run cmake -G "Unix Makefiles" \
		-DAOM_TARGET_CPU=armv7 \
        -DCMAKE_BUILD_TYPE=Release \
        -DAOM_EXTRA_C_FLAGS="-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mtune=cortex-a53" \
        -DAOM_EXTRA_CXX_FLAGS="-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mtune=cortex-a53" \
		-DENABLE_SHARED=on \
		-DENABLE_NASM=on ../aom &&
	make -j $(nproc) &&
	sudo checkinstall --default --pkgversion="0.1.0" -y
