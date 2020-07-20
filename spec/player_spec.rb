require_relative '../lib/player.rb'
RSpec.describe Player do

  describe 'play method' do 
    context 'first play' do
      before do
        @player = Player.new('Tester')
        @player.play(7)
      end   

      it 'should create a frame for the player' do
        expect(@player.frames.size).to eq(1)
      end  

      it 'should add a chance for the player frame' do
        expect(@player.frames.first.chances.size).to eq(1)
        expect(@player.frames.first.chances.first).to eq(7)
      end  
    end

    context 'next plays' do
      before do
        @player = Player.new('Tester')
        @player.play(10)
        @player.play(3)
        @player.play(7)
      end

      it 'should create a second frame for the player' do
        expect(@player.frames.size).to eq(2)
      end  

      it 'should add chances in diferent frames' do
        expect(@player.frames.first.chances.size).to eq(1)
        expect(@player.frames[1].chances.size).to eq(2)
        expect(@player.frames[1].chances.sum).to eq(10)
      end  
    end

    context 'failure' do
      before do
        @player = Player.new('Tester')
        20.times do
          @player.play(4)
        end 
      end

      it 'should raise an error' do
        expect { @player.play(7) }.to raise_error(TenPinBowlingScore::GameError, 'Game already completed')
      end     
    end

    context 'failure spare' do
      before do
        @player = Player.new('Tester')
        20.times do
          @player.play(5)
        end 
        @player.play(4)

      end

      it 'should raise an error' do
        expect { @player.play(7) }.to raise_error(TenPinBowlingScore::GameError, 'Game already completed')
      end     
    end

    context 'failure after perfect game' do
      before do
        @player = Player.new('Tester')
        12.times do
          @player.play(10)
        end 
      end

      it 'should raise an error' do
        expect { @player.play(7) }.to raise_error(TenPinBowlingScore::GameError, 'Game already completed')
      end     
    end
  end

  describe 'game_completed? method' do 
    context 'not completed yet' do
      before do
        @player = Player.new('Tester')
        3.times do
          @player.play(10)
        end 
      end

      it 'should return false' do
        expect(@player.game_completed?).to eq(false)
      end
    end

    context 'completeded yet' do
      before do
        @player = Player.new('Tester')
        12.times do
          @player.play(10)
        end 
      end

      it 'should return true' do
        expect(@player.game_completed?).to eq(true)
      end
    end
  end

  describe 'frames_to_s method' do
    before do
      @player = Player.new('Tester')
      12.times do
        @player.play(10)
      end 
    end

    it 'should return frame numbers string' do
      expect(@player.frames_to_s).to eq("\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10")
    end
  end

  describe 'chances_to_s method' do
    context 'perfect game' do
      before do
        @player = Player.new('Tester')
        12.times do
          @player.play(10)
        end 
      end

      it 'should return chances string' do
        expect(@player.chances_to_s).to eq("\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\tX\tX")
      end
    end

    context 'normal game with some spares' do
      before do
        @player = Player.new('Tester')
        6.times do
          @player.play(4)
          @player.play(5)
        end
        3.times do
          @player.play(7)
          @player.play(3)
        end
        @player.play(3)
        @player.play(3) 
      end

      it 'should return chances string' do
        expect(@player.chances_to_s).to eq("4\t5\t4\t5\t4\t5\t4\t5\t4\t5\t4\t5\t7\t/\t7\t/\t7\t/\t3\t3\t")
      end
    end

    context 'normal game with final spare' do
      before do
        @player = Player.new('Tester')
        9.times do
          @player.play(10)
        end
          @player.play(10)
          @player.play(7)
          @player.play(3)
      end

      it 'should return chances string' do
        expect(@player.chances_to_s).to eq("\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\t7\t/")
      end
    end

    context 'normal game with final spare before bonus' do
      before do
        @player = Player.new('Tester')
        9.times do
          @player.play(10)
        end
          @player.play(7)
          @player.play(3)
          @player.play(3)
      end

      it 'should return chances string' do
        expect(@player.chances_to_s).to eq("\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t7\t/\t3")
      end
    end
  end

  describe 'to_s method' do
    context 'perfect game' do
      before do
        @player = Player.new('Tester')
        12.times do
          @player.play(10)
        end 
      end

      it 'should return score string' do
        expect(@player.to_s).to eq("\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300")
      end
    end
  end
end
