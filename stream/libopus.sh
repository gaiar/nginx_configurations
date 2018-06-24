cd ~/ffmpeg_sources &&
	wget -O opus-1.2.1.tar.gz https://github.com/xiph/opus/archive/v1.2.1.tar.gz &&
	mkdir -p opus &&
	tar xvfz opus-1.2.1.tar.gz -C opus &&
	cd opus/opus* &&
	./autogen.sh &&
	auto-apt run ./configure \
		--enable-shared &&
	make -j $(nproc) &&
	sudo checkinstall --default
