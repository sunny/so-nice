module Sonice
  class AmarokPlayer < Player
    def playpause
      tell_to 'PlayPause'
    end

    def prev
      tell_to 'Prev'
    end

    def next
      tell_to 'Next'
    end

    def voldown
      tell_to 'VolumeDown 5'
    end

    def volup
      tell_to 'VolumeUp 5'
    end

    def volume
      tell_to 'VolumeGet'
    end

    def track
      get_metadata('title')
    end
    
    def artist
      get_metadata('artist')
    end
    
    def album
      get_metadata('album')
    end

    def launched?
      not %x(qdbus org.kde.amarok).match(/does not exist/)
    end

    private
    def tell_to(command)
      %x(qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.#{command}).rstrip
    end

    def get_metadata(name)
      tell_to('GetMetadata').match(/#{name}: (\S.*)/)[1] rescue nil
    end
  end
end

