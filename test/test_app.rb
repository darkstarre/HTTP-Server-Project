$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

class TestApp < Minitest::Test

  def test_it_returns_html_form_in_body
    env = {
      "REQUEST_METHOD"                 => 'POST',
      "PATH_INFO"                      => '/search',
      "SERVER_PROTOCOL"                => 'HTTP/1.1',
      "HTTP_HOST"                      => "localhost:9299",
      "HTTP_CONNECTION"                => "keep-alive",
      "CONTENT_LENGTH"                 => "17",
      "HTTP_CACHE_CONTROL"             => "max-age=0",
      "HTTP_ACCEPT"                    => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "HTTP_ORIGIN"                    => "http://localhost:9299",
      "HTTP_UPGRADE_INSECURE_REQUESTS" => "1",
      "HTTP_USER_AGENT"                => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36",
      "CONTENT_TYPE"                   => "application/x-www-form-urlencoded",
      "HTTP_REFERER"                   => "http://localhost:9299/",
      "HTTP_ACCEPT_ENCODING"           => "gzip, deflate",
      "HTTP_ACCEPT_LANGUAGE"           => "en-US,en;q=0.8",
      'BODY'                           => 'lolol=hello+world', # this one is technically not correct, but suits our needs better
    }

    assert_match /<\/form>/, Notes::Server::App.call(env)
  end
end
