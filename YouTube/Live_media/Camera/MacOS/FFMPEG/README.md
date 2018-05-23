# $1 the channel name
# $2 the icecast password
# $3 the icecast port
# $4 the icecast server

# See:
# ffmpeg -f avfoundation -list_devices true -i ""

# This works:
# ffmpeg -f avfoundation -pixel_format yuyv422 -r "25" -video_device_index 0 -i ":1" -y /tmp/1.avi

ffmpeg -f avfoundation -pixel_format yuyv422 -r "25" -video_device_index 0 -i ":1" -c:a libmp3lame -b:a 128k -legacy_icecast 1 -content_type audio/mpeg -ice_name "DemoStream" -f mp3 icecast://source:$2@$4:$3/$1.ogg
