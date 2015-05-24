# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "sonice/version"

Gem::Specification.new do |s|
  s.name        = "sonice"
  s.version     = Sonice::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sunny Ripert"]
  s.email       = ["sunny@sunfox.org"]
  s.homepage    = "http://github.com/sunny/so-nice"
  s.summary     = "Web interface to control your current music player"
  s.description = "Small Web interface to control iTunes, Spotify, " + \
                  "Rdio, MPD, Rhythmbox, Amarok and XMMS2. ♫"
  s.license     = "WTFPL"

  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| File.basename(f) }

  s.add_runtime_dependency 'anyplayer', '>= 1.1.4'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'xml-simple'
  s.add_runtime_dependency 'thin', '~> 1.6.3'

  s.add_development_dependency 'rake'
end
