#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'

require 'sinatra'
require 'haml'
require 'xmlsimple'
require 'json'
require 'open-uri'
require 'anyplayer'

def artist_image(artist)
  last_fm_uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"
  return unless artist

  artist = Rack::Utils.escape(artist)
  begin
    xml = XmlSimple.xml_in(open(last_fm_uri % artist).read.to_s)
  rescue OpenURI::HTTPError
    return nil
  end

  images = xml['images'].first['image']
  if images
    image = images[rand(images.size-1)]["sizes"].first["size"].first
    return image['content']
  end

  return nil
end

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
end

post '/player' do
  return unless settings.controls || settings.voting
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
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
    { :title => h(@title), :artist => h(@artist), :album => h(@album) }.to_json
  else
    @image_uri = artist_image(@artist)
    haml :index
  end
end

