
MUSIC_PLAYERS = []

class MusicPlayer
  def launched?
    false
  end

  def name
    self.class.to_s.gsub(/Player/, '')
  end

  def self.inherited(k)
    MUSIC_PLAYERS.push k.new
  end

  def self.launched
    MUSIC_PLAYERS.find { |player| player.launched? }
  end
end


