require 'xmlsimple'
require 'json'
require 'open-uri'

module Sonice
  class ArtistImage
    attr_reader :uri

    LAST_FM_URI = "http://ws.audioscrobbler.com/2.0/?method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"

    def initialize(artist)
      return unless artist
      artist = Rack::Utils.escape(artist)
      xml = XmlSimple.xml_in(open(LAST_FM_URI % artist).read.to_s)
      images = xml['images'].first['image']
      if images
        image = images[rand(images.size-1)]["sizes"].first["size"].first
        @uri = image['content']
      end
      rescue OpenURI::HTTPError
        ""
    end
  end
end

