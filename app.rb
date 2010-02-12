#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'lib/player'
Dir[File.dirname(__FILE__) + '/lib/players/*'].each { |f| require f }

configure do
  $player = MusicPlayer.launched or abort "Error: no music player launched!"
end

post '/player' do
  params.each { |k, v| $player.send(k) if $player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @title = $player.current_track
  @artist = $player.current_artist
  @album = $player.current_album
  haml :index
end

use_in_file_templates!

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
      %h2= @album

    %form{:method => 'post', :action => 'player'}
      %p
        %input{:type=>'submit', :value => '▸', :name=>'playpause', :title => "Play/Pause"}
        %input{:type=>'submit', :value => '←', :name=>'prev',      :title => "Previous"}
        %input{:type=>'submit', :value => '→', :name=>'next',      :title => "Next"}
        %input{:type=>'submit', :value => '♪', :name=>'voldown',   :title => "Quieter"}
        %input{:type=>'submit', :value => '♫', :name=>'volup',     :title => "Louder"}

