module Sonice
  class ItunesPlayer < Player
    def playpause
      tell_to 'playpause'
    end

    def prev
      tell_to 'previous track'
    end

    def next
      tell_to 'next track'
    end

    def voldown
      tell_to 'set sound volume to sound volume - 10'
    end

    def volup
      tell_to 'set sound volume to sound volume + 10'
    end

    def volume
      tell_to 'return sound volume'
    end

    def track
      tell_to 'return name of current track'
    end

    def artist
      tell_to 'return artist of current track'
    end

    def album
      tell_to 'return album of current track'
    end

    def launched?
      track
      $? == 0
    end

    def name
      "iTunes"
    end

    private
    def tell_to(command)
      %x(osascript -e 'tell app "iTunes" to #{command}').rstrip
    end
  end
end

