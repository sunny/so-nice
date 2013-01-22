#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'
require 'xmlsimple'

set :environment, ENV['RACK_ENV'] || :production

configure do
  set :controls, ENV['SONICE_CONTROLS'] != '0'
  set :voting, ENV['SONICE_VOTING'] != '0'
  $player = Anyplayer::launched or abort "Error: no music player launched!"
  puts "Connected to #{$player.name}"
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def artist_image(artist)
    last_fm_uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"
    return unless artist

    artist = Rack::Utils.escape(artist)
    xml = XmlSimple.xml_in(open(last_fm_uri % artist).read.to_s)
    images = xml['images'].first['image'] if xml['images']
    if images
      image = images[rand(images.size-1)]["sizes"].first["size"].first
      return image['content']
    end

    nil
  rescue OpenURI::HTTPError
    nil
  end
end

put '/player' do
  if settings.voting
    $player.vote if params['vote']
  end

  if settings.controls
    methods = %w(playpause prev next voldown volup) & params.keys
    methods.each { |method| $player.send(method) }
  end

  if !request.xhr?
    redirect '/'
  end
end

get '/' do
  @title = $player.track
  @artist = $player.artist
  @album = $player.album
  if request.xhr?
    content_type :json
    { :title => @title, :artist => @artist, :album => @album }.to_json
  else
    @image_uri = artist_image(@artist)
    haml :index
  end
end

