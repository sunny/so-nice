module Sonice
  class Noplayer < Anyplayer::Player
    def playing?
      false
    end

    def play
    end

    def pause
    end

    def prev
      super
    end

    def next
      super
    end

    def voldown
    end

    def volup
    end

    def volume
    end

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
