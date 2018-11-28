CURRENT_DIRNAME=$(dirname "$0")

source "${CURRENT_DIRNAME}/../bin/http-pull"

describe "http-pull"

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
  expected="-re -i http://example.com/vod.mp4 -c copy -f flv rtmp://localhost/http/http%253A%252F%252Fexample.com%252Fvod.mp4"
  actual=$(http_to_rtmp "http%3A%2F%2Fexample.com%2Fvod.mp4")
  test "${actual}" = "${expected}"
}
