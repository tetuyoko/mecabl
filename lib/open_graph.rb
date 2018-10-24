require 'restclient'
require 'nokogiri'

# returns false or ogimage url "string"
class OpenGraph
  def self.fetch_image_or_blank(uri)
    if image = fetch_image(uri)
      image
    else
      ""
    end
  end

  def self.fetch_image(uri)
    parse_image(RestClient.get(uri, timeout: 3, open_timeout: 3).body)
  rescue RestClient::Exception, SocketError
    false
  end

  def self.parse_image(html)
    doc = Nokogiri::HTML.parse(html)
    doc.css('meta').each do |m|
      if m.attribute('property') && m.attribute('property').to_s.match(/^og:image$/i)
        return m.attribute('content').to_s
      end
    end

    false
  end
end
