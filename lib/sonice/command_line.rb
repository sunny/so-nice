# frozen_string_literal: true

require "sonice"
require 'sonice/version'

module Sonice
  # Module CommandLine
  module CommandLine
    module_function

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
