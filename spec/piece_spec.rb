# frozen_string_literal: true

# ./spec/piece_spec.rb
require './lib/piece'
require 'rspec'

describe Piece do
  let(:piece) { Piece.new('rook', 'white') }

  describe '::possible moves' do
    it 'generates a proc that predicts how the piece moves' do
      expect(Piece.get_moveset_proc('pawn', 'white')).to be_kind_of(Proc)
      expect(piece.possible_moves.call([1, 0])).to eq([[0, 0], [1, 1], [1, 2], [2, 0], [1, 3], [3, 0], [1, 4], [4, 0], [1, 5], [5, 0], [1, 6], [6, 0], [1, 7], [7, 0]])
    end
  end

  describe '#initalize' do
    it 'holds information about color, subclass and possible moves' do
      expect(piece.color).to eql('white')
      expect(piece.subclass).to eql('rook')
    end
  end
end
