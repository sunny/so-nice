#!/usr/bin/env ruby
$LOAD_PATH.unshift 'lib'
$LOAD_PATH.unshift 'lib/players'

begin
  require 'load_error'
  require 'player'
  require 'itunes_mac'
  require 'itunes_win'
  require 'mpd'
  require 'rhythmbox'

  require 'sinatra'
  require 'haml'

rescue LoadError => e
  raise if !e.respond_to?(:retried?) or e.retried?
  require 'rubygems'
  retry
end

enable :inline_templates
set :environment, ENV['RACK_ENV'] || :production

configure do
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
end

post '/player' do
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @title = $player.current_track
  @artist = $player.artist
  @album = $player.album
  haml :index
end


__END__
@@ index
!!!
%html
  %head
    %title
      - if @artist
        = "#{@artist} &mdash; #{@title}"
      - else
        = @title
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %meta{'http-equiv' => 'Refresh', :content => 10}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css', :type => 'text/css'}
  %body
    %h1= @title
    - if @artist
      %h2= @artist
    - if @album
      %h3= @album

    %form{:method => 'post', :action => 'player'}
      %p
        %input{:type=>'submit', :value => '▸', :name=>'playpause', :title => "Play/Pause"}
        %input{:type=>'submit', :value => '←', :name=>'prev',      :title => "Previous"}
        %input{:type=>'submit', :value => '→', :name=>'next',      :title => "Next"}
        %input{:type=>'submit', :value => '♪', :name=>'voldown',   :title => "Quieter"}
        %input{:type=>'submit', :value => '♫', :name=>'volup',     :title => "Louder"}

