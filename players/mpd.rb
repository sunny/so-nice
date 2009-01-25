class MpdPlayer < MusicPlayer
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
    mpc 'volume -10%'
  end
  def volup
    mpc 'volume +10%'
  end
  def volume
  	mpc 'volume'
  end
  def current_track
    mpc 'stats'
  end
  def launched?
  	%x(mpc 2> /dev/null)
  	$? == 0
  end

  private
  def mpc(command)
    %x(mpc #{command}).rstrip
  end
end

