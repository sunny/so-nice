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
require File.dirname(__FILE__) + '/itunes'

player = ItunesPlayer.new

post '/player' do
  params.each { |k, v| player.send(k) if player.respond_to?(k) }
  redirect '/'
end

get '/' do
  @host = %x(hostname).strip
  @song = player.current_track
  haml :index
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

use_in_file_templates!

__END__
@@ index
!!!
%html
  %head
    %title
      = @song
      &mdash; Itunes
      = @host
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %meta{'http-equiv' => 'Refresh', :content => 10}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css', :type => 'text/css'}
  %body
    %h1
      Itunes
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

@@ stylesheet
body
  padding: 0 5em
  margin: 0
  background: white
  color: #333
  font: 1.5em Helvetica, sans-serif
input
  font-size: 1em
  color: inherit
  text-decoration: none
  padding: .2em .3em
  background: #2b79d4
  color: #fff
  -moz-border-radius: .4em
  -webkit-border-radius: .4em
  border: .1em solid #2b79d4
  cursor: pointer
  &:hover
    background: #83aedf
    border-color: #77a1d1

