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

# $1 the channel name
# $2 the icecast password
# $3 the icecast port
#cvlc v4l2:///dev/video0 :input-slave=alsa:// --sout '#transcode{vcodec=theo,vb=800,width=640,heigh=480,acodec=vorb,ab=128,channels=2,samplerate=44100}:duplicate{dst=std{access=shout,mux=ogg,dst=source:$password@$addr:$port/$channel},dst=display}' :sout-keep

#cvlc v4l2:///dev/video0 :input-slave=alsa:// --sout '#transcode{vcodec=theo,vb=800,scale=Auto,acodec=vorb,ab=128,channels=2,samplerate=44100}:std{access=shout,mux=ogg,dst=source:$password@$addr:$port/$channel}' :sout-keep

cvlc v4l2:///dev/video0 :input-slave=alsa://hw:0,0 --sout "#transcode{vcodec=theo,vb=800,acodec=vorb,ab=128,channels=2,samplerate=44100}:duplicate{dst=std{access=shout,mux=ogg,dst=source:$password@$addr:$port/$channel},dst=display}" :sout-keep
