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

it_configures_ffmpeg_for_rtsp_to_rtmp() {
  expected="-fflags nobuffer -flags low_delay -rtsp_transport tcp -r 30 -i http://example.com -c copy -shortest -probesize 32 -f flv rtmp://localhost/rtsp/http%253A%252F%252Fexample.com"
  actual=$(rtsp_to_rtmp "http%3A%2F%2Fexample.com")
  test "${actual}" = "${expected}"
}
