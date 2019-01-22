class Http
  require 'net/http'
  require 'uri'
  require 'json'

  def self.make_https_request(url, data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)

    # Send the request
    response = http.request(request)
    JSON.parse response.body
  end
end