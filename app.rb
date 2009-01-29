#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/players/player.rb'
Dir[File.dirname(__FILE__) + '/players/*'].each { |f| require f }

configure do
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
end

post '/player' do
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @track = $player.current_track
  haml :index
end

use_in_file_templates!

__END__
@@ index
!!!
%html
  %head
    %title
      = @track
      &mdash;
      = $player.name
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %meta{'http-equiv' => 'Refresh', :content => 10}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css', :type => 'text/css'}
  %body
    %h1
      = $player.name
      = $player.host
      ♬

    %p= @track

    %form{:method => 'post', :action => 'player'}
      %p
        %input{:type=>'submit', :value => '▸', :name=>'playpause', :title => "Play/Pause"}
        %input{:type=>'submit', :value => '←', :name=>'prev',      :title => "Previous"}
        %input{:type=>'submit', :value => '→', :name=>'next',      :title => "Next"}
        %input{:type=>'submit', :value => '♪', :name=>'voldown',   :title => "Quieter"}
        %input{:type=>'submit', :value => '♫', :name=>'volup',     :title => "Louder"}

