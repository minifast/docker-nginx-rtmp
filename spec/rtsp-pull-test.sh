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
  expected="-fflags nobuffer -flags low_delay -strict experimental -rtsp_transport tcp -r 25 -i http://example.com -c:v copy -c:a aac -ar 44100 -f flv rtmp://localhost/rtsp-25/http%253A%252F%252Fexample.com"
  actual=$(rtsp_to_rtmp "http%3A%2F%2Fexample.com" 25)
  test "${actual}" = "${expected}"
}

it_configures_ffmpeg_for_unescaped_25fps_rtsp_to_rtmp() {
  expected="-fflags nobuffer -flags low_delay -strict experimental -rtsp_transport tcp -r 25 -i http://example.com -c:v copy -c:a aac -ar 44100 -f flv rtmp://localhost/rtsp-25/http%3A%2F%2Fexample.com"
  actual=$(rtsp_to_rtmp "http%3A%2F%2Fexample.com" 25 skip)
  test "${actual}" = "${expected}"
}

it_configures_ffmpeg_for_muxed_unescaped_25fps_rtsp_to_rtmp() {
  expected="-fflags nobuffer -flags low_delay -strict experimental -rtsp_transport tcp -r 25 -i http://example.com -stream_loop -1 -i http://example.com/sound.mp3 -map 0:v -map 1:a -c:v copy -c:a aac -ar 44100 -shortest -f flv rtmp://localhost/rtsp-25/http%3A%2F%2Fexample.com^http%3A%2F%2Fexample.com%2Fsound.mp3"
  actual=$(rtsp_to_rtmp "http%3A%2F%2Fexample.com^http%3A%2F%2Fexample.com%2Fsound.mp3" 25 skip)
  test "${actual}" = "${expected}"
}
