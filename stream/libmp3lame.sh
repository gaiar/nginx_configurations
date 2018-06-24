cd ~/ffmpeg_sources &&
	wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz &&
	tar xzvf lame-3.100.tar.gz &&
	cd lame-3.100 &&
	auto-apt run ./configure \
		--enable-shared \
		--enable-nasm &&
	make -j $(nproc) &&
    sudo mkdir -p /usr/local/share/doc/lame &&
	sudo checkinstall --default
