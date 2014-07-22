# -*- encoding: utf-8 -*-
module Sonice
  # Sinatra application
  class App < Sinatra::Base
    set :port, ENV['SONICE_PORT'] || 3000
    set :controls, ENV['SONICE_CONTROLS'] != '0'
    set :voting, ENV['SONICE_VOTING'] != '0'
    set :environment, ENV['RACK_ENV'] || :production

    set :logging, true
    set :static, true
    set :public_dir, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :haml, format: :html5
    set :protection, except: :frame_options

    def initialize
      @player = player
    end

    def player
      @player ||= begin
        puts "Looking for a player..."
        player = Anyplayer::Selector.new.player
        abort "Error: no music player launched!" unless player
        puts "Connected to #{player.name}"
        player
      end
    end

    put '/player' do
      player.vote if settings.voting && params['vote']

      if settings.controls
        methods = %w(playpause prev next voldown volup) & params.keys
        methods.each { |method| player.send(method) }
      end

      redirect "/" unless request.xhr?
    end

    get '/' do
      @title = player.track
      @artist = player.artist
      @album = player.album
      if request.xhr?
        content_type :json
        { title: @title, artist: @artist, album: @album }.to_json
      else
        haml :index
      end
    end
  end
end
