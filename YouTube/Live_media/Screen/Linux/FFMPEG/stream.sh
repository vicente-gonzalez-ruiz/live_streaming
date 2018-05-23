#!/bin/bash

bitrate="1984k"
framerate=15
resolution="1600x1200"
server="rtmp://a.rtmp.youtube.com/live2"
key="12345678"

usage() {
    echo $0
    echo "Screen streaming throught YouTube Live."
    echo "  [-b bit-rate, (\"$bitrate\")]"
    echo "  [-f frame-rate, (\"$framerate\")]"
    echo "  [-k key (\"$key\)]"
    echo "  [-r resolution (\"$resolution\")]"
    echo "  [-s server (\"$server\")]"
    echo "  [-? (help)]"
}

echo $0: parsing: $@

while getopts "b:f:k:r:s:?" opt; do
    case ${opt} in
	b)
	    bitrate="${OPTARG}"
	    ;;
	f)
	    framerate="${OPTARG}"
	    ;;
	k)
	    key="${OPTARG}"
	    ;;
	r)
	    resolution="${OPTARG}"
	    ;;
	s)
	    server="${OPTARG}"
	    ;;
	?)
	    usage
	    exit 0
	    ;;
	\?)
	    echo "Invalid option: -${OPTARG}" >&2
	    usage
	    exit 1
	    ;;
	:)
	    echo "Option -${OPTARG} requires an argument." >&2
	    usage
	    exit 1
	    ;;
    esac
done

set -x
ffmpeg -f alsa \
       -ac 2 \
       -i hw:0,0 \
       -f x11grab \
       -framerate $framerate \
       -video_size $resolution \
       -i :0.0+0,0 \
       -vcodec libx264 \
       -preset veryfast \
       -maxrate $bitrate \
       -bufsize 3968k \
       -vf "format=yuv420p" \
       -g $(($framerate * 2)) \
       -acodec libmp3lame \
       -b:a 96k \
       -ar 44100 \
       -f flv \
       $server/$key
set +x
