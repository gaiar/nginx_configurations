cd ~/ffmpeg_sources &&
	wget https://www.nasm.us/pub/nasm/releasebuilds/2.14rc7/nasm-2.14rc7.tar.bz2 &&
	tar xjvf nasm-2.14rc7.tar.bz2 &&
	cd nasm-2.14rc7 &&
	./autogen.sh &&
	auto-apt run ./configure &&
	make -j $(nproc) &&
	sudo checkinstall --default
