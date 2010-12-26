module Sonice
  class MpdPlayer < Player
    def playpause
      mpc 'toggle'
    end

    def prev
      mpc 'prev'
    end

    def next
      mpc 'next'
    end

    def voldown
      mpc 'volume -10'
    end

    def volup
      mpc 'volume +10'
    end

    def volume
      mpc('volume').grep(/([0-9]+)/)
      $1
    end

    def track
      mpc '-f "%title%" current'
    end

    def artist
      mpc '-f "%artist%" current'
    end

    def album
      mpc '-f "%album%" current'
    end

    def launched?
      %x(mpc 2> /dev/null)
      $? == 0
    end

    def host
      ENV['MPD_HOST'] || super
    end

    private
    def mpc(command)
      %x(mpc #{command}).split("\n").first
    end
  end
end

