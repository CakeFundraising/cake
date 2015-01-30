class RobotsGenerator
  def self.call(env)
    body = "User-agent: *\nDisallow: /"

    headers = {
        'Content-Type'  => 'text/plain',
        'Cache-Control' => "public, max-age=#{1.year.seconds.to_i}"
    }

    [200, headers, [body]]
  rescue Errno::ENOENT
    headers = { 'Content-Type' => 'text/plain' }
    body    = '# A robots.txt is not configured'

    [404, headers, [body]]
  end
end