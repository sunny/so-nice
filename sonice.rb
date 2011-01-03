#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'

require 'sinatra'
require 'haml'

$: << File.join(File.dirname(__FILE__), 'lib')
require './sonice/artist_image'
require './sonice/player'
require './sonice/players/itunes'
require './sonice/players/itunes_win'
require './sonice/players/mpd'
require './sonice/players/rhythmbox'
require './sonice/players/xmms2'

set :environment, ENV['RACK_ENV'] || :production

configure do
  set :controls, ENV['SONICE_CONTROLS'] != '0'
  $player = Sonice::Player.launched or abort "Error: no music player launched!"
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
  @image_uri = Sonice::ArtistImage.new(@artist).uri
  if request.xhr?
    content_type :js
    erb :indexjs
  else
    haml :index
  end
end

