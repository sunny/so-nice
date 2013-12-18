require "sonice"
require 'sonice/version'

module Sonice
  module CommandLine
    extend self

    def parse(argv)
      case argv

      when []
        Sonice::App.run!

      when ["--version"]
        puts "so nice v#{Sonice::VERSION}"
        puts "https://github.com/sunny/so-nice"

      else
        puts "Usage: sonice [--version]"
        exit(1)
      end

    end
  end
end
