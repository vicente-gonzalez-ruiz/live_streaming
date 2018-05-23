#!/bin/bash

resolution="1024x768"
framerate=15
bitrate="1984k"

usage() {
    echo $0
    echo "Test the capture and coding of the screen."
    echo "  [-b bit-rate, (\"$bitrate\")]"
    echo "  [-f frame-rate, (\"$framerate\")]"
    echo "  [-r resolution (\"$resolution\")]"
    echo "  [-? (help)]"
}

echo $0: parsing: $@

while getopts "b:f:r:?" opt; do
    case ${opt} in
	b)
	    bitrate="${OPTARG}"
	    ;;
	f)
	    framerate="${OPTARG}"
	    ;;
	r)
	    resolution="${OPTARG}"
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
ffmpeg -f avfoundation \
       -i "1:0" \
       -framerate $framerate \
       -video_device_index 0 \
       -ac 2 \
       -video_size $resolution \
       -vcodec libx264 \
       -preset veryfast \
       -maxrate $bitrate \
       -bufsize 3968k \
       -g $(($framerate * 2)) \
       -acodec libmp3lame \
       -ar 44100 \
       -b:a 64k \
       -legacy_icecast 1 \
       -f flv - | ffplay -i -
set +x
