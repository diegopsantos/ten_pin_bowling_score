require_relative 'ten_pin_bowling_score.rb'

class Frame < TenPinBowlingScore

  def initialize(frame_number, previous_frame=nil)
    @chances = []
    @bonus_chance = nil
    @remaining_pins = MAX_PINS
    @frame_number = frame_number
    @previous_frame = previous_frame
    @next_frame = nil
    previous_frame.next_frame = self if previous_frame
  end

  attr_accessor :chances, :remaining_pins, :frame_number, :previous_frame, :next_frame, :bonus_chance

  def new_chance(pins)
    raise GameError.new("There is no more pins") if pins != 'F' && pins > remaining_pins
    if chances.size < 2
      @chances << pins
    else
      @bonus_chance = pins if bonus_chance?
    end
    @remaining_pins -= pins if pins != 'F'
    @remaining_pins = MAX_PINS if bonus_chance? && remaining_pins == 0
  end

  def ended?
    if frame_number == MAX_FRAMES
      chances.length == 2 && !bonus_chance?
    else
      remaining_pins == 0 || chances.length == 2
    end
  end

  def strike?
    chances.first == MAX_PINS
  end

  def spare?
    !strike? &&  chances_without_fouls.sum == 10
  end

  def spare_on_bonus_chance?
    return false if bonus_chance.nil?
    !spare? && chances[1].integer? && (chances[1] + bonus_chance == 10)
  end

  def score
    score = previous_frame&.score.to_i + chances_without_fouls.sum + bonus_chance.to_i
    score += next_frame&.bonus_for_previous_frame.to_i if strike? || spare?
    score
  end

  def bonus_for_previous_frame
    return chances_without_fouls.sum if previous_frame&.strike? && frame_number == MAX_FRAMES
    return 10 + next_frame&.chances&.first if strike? && previous_frame&.strike?
    return chances_without_fouls.sum if previous_frame&.strike?
    return chances.first if previous_frame&.spare?
    0
  end

  def chances_to_s
    if frame_number < 10
      return "\tX" if strike?
      return chances.first.to_s + "\t/" if spare?
      chances.join("\t")
    else
      chances_with_x = chances.map { |chance| chance == 10 ? 'X' : chance }
      bonus_chance_with_x = bonus_chance == 10 ? "X" : bonus_chance.to_s
      chances_to_s = ''
      chances_to_s << chances_with_x.first.to_s + "\t"
      chances_to_s << (spare? ? "/\t" : (chances_with_x[1].to_s) + "\t")
      chances_to_s << (spare_on_bonus_chance? ? "/" : bonus_chance_with_x)
      chances_to_s
    end
  end

  private

  def chances_without_fouls
    chances.select { |chance| chance != 'F' }
  end

  def bonus_chance?
    frame_number == MAX_FRAMES && (strike? || spare?) && bonus_chance == nil
  end
end
