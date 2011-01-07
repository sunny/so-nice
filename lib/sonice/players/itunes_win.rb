module Sonice
  class ItunesWinPlayer < Player
    def playpause
      @itunes.PlayPause()
    end

    def prev
      @itunes.PreviousTrack()
    end

    def next
      @itunes.NextTrack()
    end

    def voldown
      @itunes.SoundVolume=@itunes.SoundVolume - 10
    end

    def volup
      @itunes.SoundVolume=@itunes.SoundVolume + 10
    end

    def volume
      @itunes.SoundVolume
    end

    def track
      @itunes.CurrentTrack.name
    end

    def artist
      @itunes.CurrentTrack.Artist
    end

    def album
      @itunes.CurrentTrack.Album
    end

    def launched?
      return false if RUBY_PLATFORM !~ /cygwin|mswin|mingw|bccwin|wince|emx/

      begin
        require 'win32ole'
        @itunes = WIN32OLE.new("iTunes.Application")
        return true
      rescue LoadError
        return false
      end
    end

    def name
      "iTunes Windows"
    end
  end
end

