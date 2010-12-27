module Sonice
  class Xmms2Player < Player
    def playpause
      xmms2 'toggle'
    end

    def prev
      xmms2 'prev'
    end

    def next
      xmms2 'next'
    end

    def voldown
      current = volume.to_i
      new_volume = (current < 11 ? 0 : current - 10)
      xmms2 "server volume #{new_volume}"
    end

    def volup
      current = volume.to_i
      new_volume = (current > 89 ? 100 : current + 10)
      xmms2 "server volume #{new_volume}"
    end

    def volume
      #currently just the first (left?) channel
      xmms2('server volume').split("\n").first.sub /([^0-9]*)/, ''
      $1
    end

    def track
      xmms2 "status -f '${title}'"
    end

    def artist
      xmms2 "status -f '${artist}'"
    end

    def album
      xmms2 "status -f '${album}'"
    end

    def launched?
      # xmms2 autolaunches the daemon, so this should always be true
      %x(xmms2 status 2> /dev/null)
      $? == 0
    end

    def host
      ENV['XMMS_PATH'] || super
    end

    private
    def xmms2(command)
      %x(xmms2 #{command}).split("\n").first
    end
  end

end 
