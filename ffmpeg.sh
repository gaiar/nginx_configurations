ffmpeg -re -i example-vid.mp4 \
	-vcodec libx264 \
	-vprofile baseline \
	-g 30 \
	-acodec aac \
	-strict -2 \
	-f flv rtmp://localhost/show/stream

ffmpeg -c:v h264_mmal \
	-i inputfile.mp4 \
	-c:v h264_omx \
	-c:a copy \
	-b:v 1500k \
	outputfile.mp4

ffmpeg -i /dev/video0 \
	-framerate 30 \
	-video_size 720x404 \
	-vcodec h264_omx \
	-maxrate 768k \
	-bufsize 8080k \
	-vf "format=yuv420p" \
	-g 60 \
	-f flv rtmp://example.com:8081/hls/live

ffmpeg \
	-stream_loop -1 \
	-c:v h264_mmal \
	-i flower.mp4 \
	-c:v h264_omx \
	-preset:v ultrafast \
	-s 720x404 \
	-b:v 128K \
	-c:a aac \
	-f flv rtmp://localhost/show/hls

ffmpeg \
	-re \
	-stream_loop -1 \
	-c:v h264_mmal \
	-i flower.mp4 \
	-c:v h264_omx \
    -vprofile baseline \
    -video_size 720x404 \
    -maxrate 1000K \
	-bufsize 8080k \
	-c:a copy \
	-f flv rtmp://localhost/show/hls

ffmpeg -i file.mp4 \
	-c:v copy \
	-preset:v ultrafast \
	-b:v 512K \
	-c:a copy \
	-tune zerolatency \
	-f flv rtmp://localhost/hls/$name_hi

ffmpeg -i file.mp4 \
	-c:v libx264 \
	-preset:v ultrafast \
	-s 852x480 \
	-b:v 128K \
	-c:a copy \
	-tune zerolatency \
	-f flv rtmp://localhost/hls/$name_low
