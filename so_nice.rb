#!/usr/bin/env ruby
require 'sinatra'
require 'haml'

require 'lib/artist_image'
require 'lib/player'
require 'lib/players/itunes'
require 'lib/players/itunes_win'
require 'lib/players/mpd'
require 'lib/players/rhythmbox'

set :environment, ENV['RACK_ENV'] || :production
enable :inline_templates

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
  redirect '/'
end

get '/' do
  @title = $player.track
  @artist = $player.artist
  @album = $player.album
  @image_uri = ArtistImage.new(@artist).uri
  if request.env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
    erb :indexjs
  else
    haml :index
  end
end

__END__
@@ indexjs
$('#artist').text('<%=h(@artist)%>')
$('#album').text('<%=h(@album)%>')
$('#title').text('<%=h(@title)%>')
$('title').text('<%=h("#{@artist} — #{@title}")%>')
$('body').background('<%=h(@image_uri)%>')

@@ index
!!!
%html
  %head
    %title
      - if @artist
        = "#{@artist} — #{@title}"
      - else
        = @title
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css'}
  %body{:style => @image_uri ? "background-image:url(#{@image_uri})" : nil }
    %h1#title= @title
    - if @artist
      %h2#artist= @artist
    - if @album
      %h3#album= @album

    - if settings.controls
      %form{:method => 'post', :action => 'player'}
        %p
          %input{:type=>'submit', :value => '▸', :name=>'playpause', :title => "Play/Pause"}
          %input{:type=>'submit', :value => '←', :name=>'prev',      :title => "Previous"}
          %input{:type=>'submit', :value => '→', :name=>'next',      :title => "Next"}
          %input{:type=>'submit', :value => '♪', :name=>'voldown',   :title => "Quieter"}
          %input{:type=>'submit', :value => '♫', :name=>'volup',     :title => "Louder"}

    %script{:src => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js'}
    %script{:src => '/script.js'}
