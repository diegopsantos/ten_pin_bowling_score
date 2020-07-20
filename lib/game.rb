require_relative 'player.rb'
require_relative 'scoreboard.rb'
require_relative 'ten_pin_bowling_score.rb'

class Game < TenPinBowlingScore
  VALID_PINS_VALUE = %w(0 1 2 3 4 5 6 7 8 9 10 F)

  def initialize(game_file)
    @players = []
    File.foreach(game_file) do |chance|
      player_name, pins = chance.delete("\n").split("  ")
      raise GameError.new("Invalid input: Invalid pins value") unless VALID_PINS_VALUE.include?(pins)
      pins = pins.to_i unless pins == 'F'
      @player = @players.select{ |player| player.name == player_name}.first
      if @player.nil?
        @player = Player.new(player_name)
        @players << @player
      end
      @player.play(pins)
    end
  end

  attr_accessor :players

  def show_game_score
    puts Scoreboard.new(players).generate_board
  end
end

