#!/usr/bin/env ruby
# Sinatra-Itunes
# Small app to control your Itunes via HTTP.
#
# By Sunny Ripert (http://sunfox.org)
# Under the WTFPL
#
# Usage: `$ ruby itunes.rb`, then visit `http://localhost:4567`
# Requires sinatra: `$ sudo gem install sinatra`

require 'rubygems'
require 'sinatra'

get '/do' do
  %x(osascript -e 'tell app "iTunes" to #{params[:command]}');
  redirect '/'
end

get '/' do
  @title = "Itunes #{%x{hostname}}"
  @song = %x(osascript -e 'tell app "iTunes" to return (artist of current track) & " - " & (name of current track)')
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
    %title= @title
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %meta{'http-equiv' => 'Refresh', :content => 10}
    %link{:rel => 'stylesheet', :href => '/stylesheet.css', :type => 'text/css'}
  %body
    %h1
      = @title
      ♬

    %p= @song

    %p
      %a{:href => '/do?command=playpause', :title => "Play/Pause"} ▸
      %a{:href => '/do?command=previous track', :title => "Previous"} ←
      %a{:href => '/do?command=next track', :title => "Next"} →
      %a{:href => '/do?command=set sound volume to sound volume - 10', :title => "Quieter"} ♪
      %a{:href => '/do?command=set sound volume to sound volume %2B 10', :title => "Louder"} ♫

@@ stylesheet
body
  padding: 0 5em
  margin: 0
  background: white
  color: #333
  font: 1.5em Helvetica, sans-serif
a
  color: inherit
  text-decoration: none
  padding: .2em .3em
  background: #ccc
  color: white
  -moz-border-radius: .2em
  -webkit-border-radius: .2em
a:hover
  background: #999

