# frozen_string_literal: true

# ./spec/piece_spec.rb
require './lib/piece'
require 'rspec'

describe Piece do
  let(:piece) { Piece.new('white', 'pawn') }

  describe '::possible moves' do
    it 'generates a proc that predicts how the piece moves' do
      expect(Piece.get_moveset_proc('pawn')).to be_kind_of(Proc)
      expect(piece.possible_moves.call([1, 0])).to eq([[2, -1], [2, 0], [2, 1]])
    end
  end

  describe '#initalize' do
    it 'holds information about colour, subclass and possible moves' do
      expect(piece.colour).to eql('white')
      expect(piece.subclass).to eql('rook')
    end
  end
end
