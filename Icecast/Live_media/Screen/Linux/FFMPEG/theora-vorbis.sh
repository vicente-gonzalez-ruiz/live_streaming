#!/bin/bash

addr="localhost"
port=8000
channel="test.ogg"
password="1qaz"

usage() {
    echo $0
    echo "Captures video (Theora) and audio (Vorbis) and feeds an Icecast server."
    echo "  [-c Icecast mount-point (\"$channel\")]"
    echo "  [-w Icecast password, (\"$password\")]"
    echo "  [-a server address, (\"$addr\")]"
    echo "  [-p server port, (\"$port\"]"
    echo "  [-? (help)]"
}

echo $0: parsing: $@

while getopts "c:w:a:p:?" opt; do
    case ${opt} in
	c)
	    channel="${OPTARG}"
	    ;;
	w)
	    password="${OPTARG}"
	    ;;
	a)
	    addr="${OPTARG}"
	    ;;
	p)
	    port="${OPTARG}"
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

echo "Feeding http://$addr:$port/$channel ..."

# ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 30 -i /dev/video0 -f avi - | ffplay -i -

# ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 30 -i /dev/video0 -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 -f ogg - | ffplay -i -

# ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 15 -i /dev/video0 -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 5 -f ogg - | ffplay -i -
# ffmpeg -f alsa -i default -f video4linux2 -s 352x288 -r 15 -i /dev/video0 -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 5 -f ogg - | ffplay -i -

# ffmpeg -f x11grab -framerate 25 -video_size cif -i :0.0 -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 5 -f ogg - | ffplay -i -

# ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 15 -i /dev/video0 -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 5 -f ogg - | oggfwd localhost 8000 1qaz /test.ogg

# ffmpeg -f x11grab -framerate 25 -video_size cif -i :0.0 -codec:v libtheora -qscale:v 10 -codec:a libvorbis -qscale:a 5 -f ogg - | oggfwd localhost 8000 1qaz /test.ogg
    
echo "ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 30 -i /dev/video0 -f avi - | ffmpeg2theora -a 0 -v 5 -f avi -x 640 -y 480 -o /dev/stdout - | oggfwd $addr $port $password /$channel"
#ffmpeg -f alsa -i default -f video4linux2 -s 640x480 -r 30 -i /dev/video0 -f avi - | ffmpeg2theora -a 0 -v 5 -f avi -x 640 -y 480 -o /dev/stdout - | oggfwd $addr $port $password /$channel
