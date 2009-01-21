
class ItunesPlayer
  def playpause
    cmd 'playpause'
  end
  def prev
    cmd 'previous track'
  end
  def next
    cmd 'next track'
  end
  def voldown
    cmd 'set sound volume to sound volume - 10'
  end
  def volup
    cmd 'set sound volume to sound volume + 10'
  end
  def current_track
    cmd 'return (artist of current track) & " - " & (name of current track)'
  end

  private
  def cmd(command)
    %x(osascript -e 'tell app "iTunes" to #{command}').rstrip
  end
end
