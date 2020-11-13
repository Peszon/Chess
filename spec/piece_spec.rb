# frozen_string_literal: true

# ./spec/piece_spec.rb
require './lib/piece'
require 'rspec'

describe Piece do
  let(:piece) { Piece.new('white', 'rook', proc { |x| [x + 1, x + 2, x + 3] }) }

  describe '#initalize' do
    it 'holds information about colour, subclass and possible moves' do
      expect(piece.colour).to eql('white')
      expect(piece.subclass).to eql('rook')
      expect(piece.possible_moves.call(1)).to eql([2, 3, 4])
    end
  end
end
