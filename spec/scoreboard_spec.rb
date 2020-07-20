require_relative '../lib/scoreboard.rb'
require_relative '../lib/player.rb'
RSpec.describe Scoreboard do
  describe 'generate_board' do
    before do 
      @player1 = Player.new('Tester 1')
      6.times do
        @player1.play(4)
        @player1.play(5)
      end
      3.times do
        @player1.play(7)
        @player1.play(3)
      end
      @player1.play(3)
      @player1.play(3) 

      @player2 = Player.new('Tester 2')
      12.times do
        @player2.play(10)
      end

      @scoreboard = Scoreboard.new([@player1, @player2])
      @generated_scoreboard = "Tester 1\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nPinfalls\t\t4\t5\t4\t5\t4\t5\t4\t5\t4\t5\t4\t5\t7\t/\t7\t/\t7\t/\t3\t3\t\nScore\t\t\t9\t\t18\t\t27\t\t36\t\t45\t\t54\t\t71\t\t88\t\t101\t\t107\nTester 2\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nPinfalls\t\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\tX\tX\nScore\t\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300\n"
    end

    it 'should print the scoreboard' do
      expect(@scoreboard.generate_board).to eq(@generated_scoreboard)
    end
  end
end