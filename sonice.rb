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
  set :overlay, ENV['SONICE_OVERLAY'] != '0'
  set :protection, except: :frame_options

  $player = Anyplayer::Selector.new.player
  abort "Error: no music player launched!" if !$player
  puts "Connected to #{$player.name}"
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
    haml :index
  end
end

