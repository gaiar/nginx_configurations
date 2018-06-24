cd ~/ffmpeg_sources &&
	wget -O fdk-aac-0.1.6.tar.gz https://github.com/mstorsjo/fdk-aac/archive/v0.1.6.tar.gz &&
	mkdir -p fdk-aac &&
	tar xvfz fdk-aac-0.1.6.tar.gz -C fdk-aac &&
	cd fdk-aac/fdk-aac* &&
	autoreconf -fiv &&
	auto-apt run ./configure \
		--enable-shared &&
	make -j $(nproc) &&
	sudo checkinstall --default
