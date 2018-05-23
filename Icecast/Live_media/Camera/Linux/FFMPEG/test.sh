#!/bin/bash

resolution="640x480"
framerate=30
bitrate="600k"

usage() {
    echo $0
    echo "Test the capture of the WebCam."
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

ffmpeg -f alsa -i default -f video4linux2 -s $resolution -r $framerate -i /dev/video0 -vcodec libx264 -b:v $bitrate -acodec libmp3lame -b:a 64k -f avi - | ffplay -i -
