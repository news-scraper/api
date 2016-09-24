require 'uri'
require 'net/http'
require 'openssl'

class UrlResolver
  def self.resolve(uri_str, agent = 'curl/7.43.0', max_attempts = 10, timeout = 10)
    attempts = 0
    cookie = nil
    uri_str = "http://#{uri_str}" unless uri_str.start_with?('http')

    until attempts >= max_attempts
      attempts += 1

      url = URI.parse(uri_str)
      http = Net::HTTP.new(url.host, url.port)
      http.open_timeout = timeout
      http.read_timeout = timeout
      path = url.path
      path = '/' if path == ''
      path += '?' + url.query unless url.query.nil?

      params = { 'User-Agent' => agent, 'Accept' => '*/*' }
      params['Cookie'] = cookie unless cookie.nil?
      request = Net::HTTP::Get.new(path, params)

      if url.instance_of?(URI::HTTPS)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.request(request)

      case response
      when Net::HTTPSuccess then
        break
      when Net::HTTPRedirection then
        location = response['Location']
        cookie = response['Set-Cookie']
        new_uri = URI.parse(location)
        uri_str = if new_uri.relative?
          url + location
        else
          new_uri.to_s
        end
      else
        raise 'Unexpected response: ' + response.inspect
      end

    end
    raise 'Too many http redirects' if attempts == max_attempts
    response.body
  end
end
