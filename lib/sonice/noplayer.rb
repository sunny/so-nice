# frozen_string_literal: true

module Sonice
  # A null-object that represents a player when none was found.
  class Noplayer < Anyplayer::Player
    def playing?
      false
    end

    def play; end

    def pause; end

    def voldown; end

    def volup; end

    def volume; end

    def track
      nil
    end

    def artist
      nil
    end

    def album
      nil
    end

    def launched?
      false
    end

    def name
      "no player"
    end
  end
end
