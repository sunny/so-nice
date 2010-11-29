class RhythmboxPlayer < MusicPlayer
  def playpause
    tell_to 'play-pause'
  end

  def prev
    tell_to 'previous'
  end

  def next
    tell_to 'next'
  end

  def voldown
    tell_to 'volume-down'
  end

  def volup
    tell_to 'volume-up'
  end

  def volume
    tell_to 'print-volume'
  end

  def track
    tell_to 'print-playing-format=%tt'
  end

  def artist
    tell_to 'print-playing-format=%ta'
  end
  
  def album
    tell_to 'print-playing-format=%at'
  end

  def launched?
    %x(rhythmbox-client --no-start --print-playing 2>/dev/null).rstrip != ""
  end

  private
  def tell_to(command)
    %x(rhythmbox-client --no-start --#{command}).rstrip
  end
end
