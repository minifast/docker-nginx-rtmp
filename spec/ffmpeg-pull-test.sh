CURRENT_DIRNAME=$(dirname "$0")

source "${CURRENT_DIRNAME}/../bin/ffmpeg-pull"

describe "ffmpeg-pull"

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
