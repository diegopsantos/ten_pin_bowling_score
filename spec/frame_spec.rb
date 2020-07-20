require_relative '../lib/frame.rb'
RSpec.describe Frame do
  describe 'new_chance method' do 
    context 'normal chance' do
      before do
        @frame = Frame.new(1)
        @frame.new_chance(5)
      end

      it 'should add a new chance' do
        expect(@frame.chances.length).to eq(1)
        expect(@frame.chances.first).to eq(5)
        expect(@frame.remaining_pins).to eq(5)
      end

      it 'should not be a strike' do
        expect(@frame.strike?).to eq(false)
      end
    end

    context 'strike' do
      before do
        @frame = Frame.new(1)
        @frame.new_chance(10)
      end

      it 'should add a new chance' do
        expect(@frame.chances.length).to eq(1)
        expect(@frame.chances.first).to eq(10)
        expect(@frame.remaining_pins).to eq(0)
      end

      it 'should be a strike' do
        expect(@frame.strike?).to eq(true)
      end
    end

    context 'spare' do
      before do
        @frame = Frame.new(1)
        @frame.new_chance(7)
        @frame.new_chance(3)
      end


      it 'should add two new chance' do
        expect(@frame.chances.length).to eq(2)
        expect(@frame.chances.sum).to eq(10)
        expect(@frame.remaining_pins).to eq(0)
      end

      it 'should not be a strike' do
        expect(@frame.strike?).to eq(false)
      end

      it 'should be a spare' do
        expect(@frame.spare?).to eq(true)
      end
    end

    context 'last frame strike' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(10)
        @frame.new_chance(5)
        @frame.new_chance(2)       
      end

      it 'should have three chances' do
        expect(@frame.chances.length).to eq(2)
        expect(@frame.bonus_chance).to eq(2)
        expect(@frame.remaining_pins).to eq(3)
      end
    end

    context 'last frame two strike' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(10)
        @frame.new_chance(10)
        @frame.new_chance(9)
      end

      it 'should have three chances' do
        expect(@frame.chances.length).to eq(2)
        expect(@frame.bonus_chance).to eq(9)
        expect(@frame.remaining_pins).to eq(1)
      end
    end

    context 'last frame strike with spare on third chance' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(10)
        @frame.new_chance(7)
        @frame.new_chance(3)
      end

      it 'sshould have three chances' do
        expect(@frame.chances.length).to eq(2)
        expect(@frame.bonus_chance).to eq(3)
        expect(@frame.remaining_pins).to eq(0)
      end
    end

    context 'last frame strike fourth chance try' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(10)
        @frame.new_chance(7)
        @frame.new_chance(3)
      end

      it 'should raise an exception' do
        expect{ @frame.new_chance(1) }.to raise_error(TenPinBowlingScore::GameError, 'There is no more pins')
      end
    end

    context 'last frame spare on second chance' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(8)
        @frame.new_chance(2)
        @frame.new_chance(10)
      end

      it 'should have three chances' do
        expect(@frame.chances.length).to eq(2)
        expect(@frame.bonus_chance).to eq(10)
        expect(@frame.remaining_pins).to eq(0)
      end
    end

    context 'failure' do
      before do
        @frame = Frame.new(1)
        @frame.new_chance(10)
      end

      it 'should raise an exception' do
        expect{ @frame.new_chance(10) }.to raise_error(TenPinBowlingScore::GameError, 'There is no more pins')
        expect(@frame.chances.length).to eq(1)
      end
    end
  end

  describe 'ended? method' do
    context 'normal frame' do
       before do
        @frame = Frame.new(1)
        @frame.new_chance(3)
        @frame.new_chance(4)
      end

      it 'should return true' do
        expect(@frame.ended?).to eq(true)
      end
    end

    context 'striked normal frame' do
       before do
        @frame = Frame.new(1)
        @frame.new_chance(10)
      end

      it 'should return true' do
        expect(@frame.ended?).to eq(true)
      end
    end

    context 'not ended normal frame' do
       before do
        @frame = Frame.new(1)
        @frame.new_chance(9)
      end

      it 'should return false' do
        expect(@frame.ended?).to eq(false)
      end
    end

    context 'not ended last frame stike' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(10)
      end

      it 'should return false' do
        expect(@frame.ended?).to eq(false)
      end
    end

    context 'not ended last frame spare' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(9)
        @frame.new_chance(1)
      end

      it 'should return false' do
        expect(@frame.ended?).to eq(false)
      end
    end

    context 'ended last frame' do
      before do
        @frame = Frame.new(10)
        @frame.new_chance(9)
        @frame.new_chance(0)
      end

      it 'should return true' do
        expect(@frame.ended?).to eq(true)
      end
    end
  end

  describe 'bonus_for_previous_frame method' do
    before do
      @frame = Frame.new(1)
      @frame.new_chance(9)
      @frame.new_chance(0)
      @frame_2 = Frame.new(2, @frame)
      @frame_2.new_chance(10)
      @frame_3 = Frame.new(3, @frame_2)
      @frame_3.new_chance(3)
      @frame_3.new_chance(7)
      @frame_4 = Frame.new(4, @frame_3)
      @frame_4.new_chance(3)
      @frame_4.new_chance(1)
    end

    it 'should return 0 for frame 1' do
      expect(@frame.bonus_for_previous_frame).to eq(0)
    end

    it 'should return 10 for frame 2' do
      expect(@frame_3.bonus_for_previous_frame).to eq(10)
    end

    it 'should return 3 for frame 3' do
      expect(@frame_4.bonus_for_previous_frame).to eq(3)
    end
  end

  describe 'score method' do
    before do
      @frame = Frame.new(1)
      @frame.new_chance(9)
      @frame.new_chance(0)
      @frame_2 = Frame.new(2, @frame)
      @frame_2.new_chance(10)
      @frame_3 = Frame.new(3, @frame_2)
      @frame_3.new_chance(10)
      @frame_4 = Frame.new(4, @frame_3)
      @frame_4.new_chance(3)
      @frame_4.new_chance(7)
    end

    it 'should return 9 for frame 1' do
      expect(@frame.score).to eq(9)
    end

    it 'should return 32 for frame 2' do
      expect(@frame_2.score).to eq(32)
    end

    it 'should return 46 for frame 3' do
      expect(@frame_3.score).to eq(52)
    end

    it 'should return 46 for frame 4' do
      expect(@frame_4.score).to eq(62) # In this case we doesn't have the next frame yet!
    end
  end
end
