require 'lib/util/os_finder'
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
    puts "Is the OS Linux #{OS.linux?}" 
    if OS.linux? and player.name.downcase.include? "itunes"
        puts 'Escaping iTunes if OS is Linux'
        return 
    else
        %x(osascript -e 'tell app "System Events" to count (every process whose name is "iTunes")' 2>/dev/null).rstrip
    end
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

