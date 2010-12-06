#!/usr/bin/env ruby
require 'sinatra'
require 'haml'

require './lib/artist_image'
require './lib/player'
require './lib/players/itunes'
require './lib/players/itunes_win'
require './lib/players/mpd'
require './lib/players/rhythmbox'

set :environment, ENV['RACK_ENV'] || :production

configure do
  set :controls, ENV['SONICE_CONTROLS'] != '0'
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
  puts "Connected to #{$player.name}"
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

post '/player' do
  return if !settings.controls
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  if !request.xhr?
    redirect '/'
  end
end

get '/' do
  @title = $player.track
  @artist = $player.artist
  @album = $player.album
  @image_uri = ArtistImage.new(@artist).uri
  if request.xhr?
    content_type :js
    erb :indexjs
  else
    haml :index
  end
end
