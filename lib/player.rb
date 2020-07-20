require_relative 'frame.rb'
require_relative 'ten_pin_bowling_score.rb'

class Player < TenPinBowlingScore

  def initialize(name)
    @name = name
    @frames = []
    new_frame
  end

  attr_reader :frames, :name

  def play(pins)
    raise GameError.new("Game already completed") if game_completed?
    new_frame(frames.last) if frames.last.ended? && !game_completed?
    frames.last.new_chance(pins)
  end

  def game_completed?
    frames.length >= MAX_FRAMES && frames[MAX_FRAMES - 1].ended?
  end

  def frames_to_s
    "\t" + frames.collect{ |frame| frame.frame_number}.flatten.join("\t\t")
  end

  def chances_to_s
    frames.collect{ |frame| frame.chances_to_s}.flatten.join("\t")
  end

  def to_s
    "\t" + frames.collect{ |frame| frame.score}.join("\t\t")
  end

  private
  def new_frame(last_frame=nil)
    frames << Frame.new(@frames.length + 1, last_frame)
  end
end