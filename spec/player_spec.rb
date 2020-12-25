require './lib/player'

describe Player do
  let(:player) { Player.new('white') }

  before(:all) do
    @original_stdout = $stdout
    @original_stderr = $stderr
    $stdout = File.open(File::NULL, 'w')
    $stderr = File.open(File::NULL, 'w')
  end

  after(:all) do
    $stdout = @original_stdout
    $stderr = @original_stderr
    @original_stdout = nil
    @original_stderr = nil
  end

  describe '#initialize' do
    it 'should have a color parameter' do
      expect(player.color).to eql('white')
    end
  end

  describe '#ask_for_move' do
    it 'should return the player input in a coordinate array and translate it' do
      allow(player).to receive(:gets).and_return("b1\n")
      expect(player.ask_for_move).to eql([[0, 1], [0, 1]])
    end

    it 'should ask util the player inputs the correct format' do
      allow(player).to receive(:gets).and_return("b4\n")
      expect(player.ask_for_move).to eql([[3, 1], [3, 1]])
    end

    it 'should return save when the input is save' do
      allow(player).to receive(:gets).and_return("save\n")
      expect(player.ask_for_move).to eql('save')
    end
  end

  describe '#ask for promotion' do
    it 'should display a message and return a number depending on player input' do
      allow(player).to receive(:gets).and_return("2\n")
      expect(player.ask_for_promotion).to eql('2')
    end
  end
end
