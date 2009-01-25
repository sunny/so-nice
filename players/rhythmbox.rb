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

  def current_track
    tell_to 'print-playing'
  end

	def launched?
		current_track != ""
	end

  private
  def tell_to(command)
    %x(rhythmbox-client --no-start --#{command}).rstrip
  end
end
