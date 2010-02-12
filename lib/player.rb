
class MusicPlayer
  MUSIC_PLAYERS = []

  def launched?
    false
  end

  def name
    self.class.to_s.gsub(/Player/, '')
  end

  def host
    %x(hostname).strip
  end

  def self.inherited(k)
    MUSIC_PLAYERS.push k.new
  end

  def self.launched
    MUSIC_PLAYERS.find { |player| player.launched? }
  end


  def current_artist; end
  def current_album; end
end


