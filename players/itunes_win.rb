class ItunesPlayer_Win < MusicPlayer
  def playpause

  end

  def prev

  end

  def next

  end

  def voldown

  end

  def volup

  end

  def volume

  end

  def current_track

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
