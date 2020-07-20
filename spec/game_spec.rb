require_relative '../lib/game.rb'

RSpec.describe Game do
  describe 'normal game' do
    before do
      @game = Game.new(File.dirname(__FILE__) + '/fixtures/files/game_example.txt')
      @expected_result = "Jeff\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nPinfalls\t\t\tX\t7\t/\t9\t0\t\tX\t0\t8\t8\t/\tF\t6\t\tX\t\tX\tX\t8\t1\nScore\t\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\nJohn\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nPinfalls\t\t3\t/\t6\t3\t\tX\t8\t1\t\tX\t\tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\nScore\t\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151\n"

    end

    it 'should print the game score' do
      expect{ @game.show_game_score }.to output(@expected_result).to_stdout
    end
  end

  describe 'perfect game' do
    before do
      @game = Game.new(File.dirname(__FILE__) + '/fixtures/files/perfect_game_example.txt')
      @expected_result = "Carl\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nPinfalls\t\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\tX\tX\nScore\t\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300\n"

    end

    it 'should print the game score' do
      expect{ @game.show_game_score }.to output(@expected_result).to_stdout
    end
  end

  describe 'zero game' do
    before do
      @game = Game.new(File.dirname(__FILE__) + '/fixtures/files/zero_game_example.txt')
      @expected_result = "Carl\nFrame\t\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\nPinfalls\t\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\nScore\t\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\n"

    end

    it 'should print the game score' do
      expect{ @game.show_game_score }.to output(@expected_result).to_stdout
    end
  end
end