# frozen_string_literal: true

module Sonice
  # Sinatra application
  class App < Sinatra::Base
    set :port, ENV['SONICE_PORT'] || 3000
    set :controls, ENV['SONICE_CONTROLS'] != '0'
    set :voting, ENV['SONICE_VOTING'] != '0'
    set :environment, ENV['RACK_ENV'] || :production

    set :logging, true
    set :static, true
    set :public_dir, File.expand_path('public', __dir__)
    set :views, File.expand_path('views', __dir__)
    set :protection, except: :frame_options

    def player_instance
      return @player if @player&.launched?

      @player = Anyplayer::Selector.new.player || Noplayer.new
    end

    put '/player' do
      player = player_instance

      player.vote if settings.voting && params['vote']

      if settings.controls
        methods = %w[playpause prev next voldown volup] & params.keys
        methods.each { |method| player.send(method) }
      end

      redirect "/" unless request.xhr?
    end

    get '/' do
      player = player_instance

      @title = player.track
      @artist = player.artist
      @album = player.album
      @connected = player.launched?

      if request.xhr?
        content_type :json
        { title: @title,
          artist: @artist,
          album: @album,
          connected: @connected }.to_json
      else
        erb :index
      end
    end
  end
end
