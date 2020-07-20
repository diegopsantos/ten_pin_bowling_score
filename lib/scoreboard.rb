class Scoreboard

  def initialize(players)
    @players = players
  end

  def generate_board
    board = ''
    @players.each do |player|
      board << player.name + "\n"
      board << "Frame\t\t" + player.frames_to_s + "\n"
      board << "Pinfalls\t\t" + player.chances_to_s + "\n"
      board << "Score\t\t" + player.to_s + "\n"
    end
    board
  end

end