# ./lib/piece.rb

class Piece
  attr_reader :colour, :subclass, :possible_moves

  def initialize(colour, subclass, possible_moves)
    @colour = colour
    @subclass = subclass
    @possible_moves = possible_moves
  end
end
