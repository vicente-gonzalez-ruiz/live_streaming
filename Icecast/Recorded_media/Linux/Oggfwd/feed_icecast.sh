#!/bin/bash

icecast_name="localhost"
icecast_port=8000
video=~/Videos/Big_Buck_Bunny_small.ogv
channel=Big_Buck_Bunny_small.ogv
password=hackme

usage() {
    echo $0
    echo "Feeds the Icecast server."
    echo "  [-c (icecast mount-point, \"$channel\" by default)]"
    echo "  [-w (icecast password, \"$password\" by default)]"
    echo "  [-a (icecast hostname, $icecast_name by default)]"
    echo "  [-p (icecast port, $icecast_port by default)]"
    echo "  [-v (video file-name, \"$video\" by default)]"
    echo "  [-? (help)]"
}

echo $0: parsing: $@

while getopts "c:w:a:p:v:?" opt; do
    case ${opt} in
	c)
	    channel="${OPTARG}"
	    ;;
	w)
	    password="${OPTARG}"
	    ;;
	a)
	    icecast_name="${OPTARG}"
	    ;;
	p)
	    icecast_port="${OPTARG}"
	    ;;
	v)
	    video="${OPTARG}"
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

echo "Feeding http://$icecast_name:$icecast_port/$channel with \"$video\" forever ..."

set -x

while true
do
    oggfwd $icecast_name $icecast_port $password $channel < $video
    sleep 1
done

set +x
