CURRENT_DIRNAME=$(dirname "$0")

source "${CURRENT_DIRNAME}/../bin/rtsp-pull"

describe "rtsp-pull"

it_decodes_urls() {
  expected="hi there"
  actual=$(urldecode "hi%20there")
  test "${actual}" = "${expected}"
}

it_double_encodes_urls() {
  expected="hi%2520there"
  actual=$(overencode "hi%20there")
  test "${actual}" = "${expected}"
}

it_configures_ffmpeg_for_25fps_rtsp_to_rtmp() {
  expected="-fflags nobuffer -fflags +genpts -fflags +igndts -flags low_delay -rtsp_transport tcp -r 50 -i http://example.com/source -map_metadata 0:s:0 -c copy -f flv rtmp://localhost/rtsp-25/destination"
  actual=$(rtsp_to_rtmp "http://example.com/source" "destination" 25)
  test "${actual}" = "${expected}"
}

it_configures_ffmpeg_for_muxed_25fps_rtsp_to_rtmp() {
  expected="-fflags nobuffer -fflags +genpts -fflags +igndts -flags low_delay -rtsp_transport tcp -r 50 -i http://example.com/source -fflags +igndts -fflags +genpts -stream_loop -1 -i http://example.com/audio.mp3 -map 0:v -map 1:a -map_metadata 0:s:0 -c copy -f flv rtmp://localhost/rtsp-25/destination"
  actual=$(rtsp_to_rtmp "http://example.com/source" "destination" 25 "http://example.com/audio.mp3")
  test "${actual}" = "${expected}"
}
