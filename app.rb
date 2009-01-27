#!/usr/bin/env ruby
# Sinatra-Itunes
# Small app to control your Itunes via HTTP.
#
# By Sunny Ripert (http://sunfox.org)
# Under the WTFPL
#
# Usage: `$ ruby app.rb`, then visit `http://localhost:4567`
# Requires sinatra: `$ sudo gem install sinatra`

require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/players/player.rb'
Dir[File.dirname(__FILE__) + '/players/*'].each { |f| require f }

player = MusicPlayer.launched or abort "Error: no music player launched!"

post '/player' do
  params.each { |k, v| player.send(k) if player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @host = %x(hostname).strip
  @song = player.current_track
  @player_name = player.name
  haml :index
end

use_in_file_templates!

__END__
@@ index
!!!
%html
  %head
    %title
      = @song
      &mdash;
      = @player_name
      = @host
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %meta{'http-equiv' => 'Refresh', :content => 10}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css', :type => 'text/css'}
  %body
    %h1
      = @player_name
      = @host
      ♬

    %p= @song

    %form{:method => 'post', :action => 'player'}
      %p
        %input{:type=>'submit', :value => '▸', :name=>'playpause', :title => "Play/Pause"}
        %input{:type=>'submit', :value => '←', :name=>'prev',      :title => "Previous"}
        %input{:type=>'submit', :value => '→', :name=>'next',      :title => "Next"}
        %input{:type=>'submit', :value => '♪', :name=>'voldown',   :title => "Quieter"}
        %input{:type=>'submit', :value => '♫', :name=>'volup',     :title => "Louder"}

