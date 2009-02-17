#!/usr/bin/env ruby

begin
  require 'sinatra'
  require 'haml'
rescue LoadError => e
  e.message.gsub! /^no such file to load -- (.*)$/,
    "\\0\nI'm sorry, I couldn't load the '\\1' library.\n" + \
    "You should try using the rubygem:\n" + \
    "  $ sudo gem install \\1\n" + \
    "  $ ruby -rubygems #{$0} #{ARGV.join(' ')}\n"
  raise e.class, e.message
end

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

