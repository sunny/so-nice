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

    def get_player
      return @player if @player && @player.launched?
      @player = Anyplayer::Selector.new.player || Noplayer.new
    end

    put '/player' do
      player = get_player

      player.vote if settings.voting && params['vote']

      if settings.controls
        methods = %w(playpause prev next voldown volup) & params.keys
        methods.each { |method| player.send(method) }
      end

      redirect "/" unless request.xhr?
    end

    get '/' do
      player = get_player

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
