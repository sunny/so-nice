class ItunesPlayer_Win < MusicPlayer
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

  def current_track
    curTrack=@itunes.CurrentTrack
    if(curTrack)
      return (curTrack.Artist + " - " + curTrack.name)
    end
    ""
  end

  def launched?
    require 'win32ole'
    @itunes = WIN32OLE.new("iTunes.Application")
    print "Windows iTunes driver launched :)\n"
    return true
  rescue
    print "Could not load iTunes windows driver\n"
    return false
  end

  def name
    "iTunes (Windows)"
  end
end
