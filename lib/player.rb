class MusicPlayer
  MUSIC_PLAYERS = []

  def name
    self.class.to_s.gsub(/Player/, '')
  end

  def host
    %x(hostname).strip
  end

  [:launched?, :playpause, :next, :prev,
    :voldown, :volup, :volume,
    :track, :artist, :album
  ].each do |method|
    define_method method do
      raise NotImplementedError, "this player needs a #{method} method"
    end
  end

  def self.inherited(k)
    MUSIC_PLAYERS.push k.new
  end

  def self.launched
    MUSIC_PLAYERS.find { |player| player.launched? }
  end
end


