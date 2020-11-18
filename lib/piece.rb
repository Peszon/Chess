# frozen_string_literal: true

# subclass of the piece is it's type "pawn", "knight", or "queen" e.v.

# ./lib/piece.rb

class Piece
  attr_reader :colour, :subclass, :possible_moves

  def self.get_moveset_proc(subclass, colour)
    case subclass
    when 'pawn' #add moveset for black pawns aswell!
      if colour == "white"
        proc do |start_coordinates|
          all_moves = [[start_coordinates[0] + 1, start_coordinates[1] - 1],
                       [start_coordinates[0] + 1, start_coordinates[1]],
                       [start_coordinates[0] + 2, start_coordinates[1]],
                       [start_coordinates[0] + 1, start_coordinates[1] + 1]]

          Piece.clear_out_of_bounds(all_moves)
        end 
      else
        proc do |start_coordinates|
          all_moves = [[start_coordinates[0] - 1, start_coordinates[1] - 1],
                       [start_coordinates[0] - 1, start_coordinates[1]],
                       [start_coordinates[0] - 2, start_coordinates[1]],
                       [start_coordinates[0] - 1, start_coordinates[1] + 1]]

          Piece.clear_out_of_bounds(all_moves)
        end 
      end 
    when 'rook'
      proc do |start_coordinates|
        all_moves = []
        0.upto(7) do |i|
          all_moves << [start_coordinates[0], i]
          all_moves << [i, start_coordinates[1]]
        end
        
        all_moves.delete(start_coordinates)
        Piece.clear_out_of_bounds(all_moves)
      end
    when 'knight'
      proc do |start_coordinates|
        all_moves = [[start_coordinates[0] + 2, start_coordinates[1] + 1],
                     [start_coordinates[0] + 2, start_coordinates[1] - 1],
                     [start_coordinates[0] + 1, start_coordinates[1] + 2],
                     [start_coordinates[0] + 1, start_coordinates[1] - 2],
                     [start_coordinates[0] - 1, start_coordinates[1] + 2],
                     [start_coordinates[0] - 1, start_coordinates[1] - 2],
                     [start_coordinates[0] - 2, start_coordinates[1] + 1],
                     [start_coordinates[0] - 2, start_coordinates[1] - 1]]
        
        Piece.clear_out_of_bounds(all_moves)
      end
    when 'bishop'
      proc do |start_coordinates|
        all_moves = []
        1.upto(7) do |i|
          all_moves << [start_coordinates[0] + i, start_coordinates[1] + i]
          all_moves << [start_coordinates[0] - i, start_coordinates[1] + i]
          all_moves << [start_coordinates[0] + i, start_coordinates[1] - i]
          all_moves << [start_coordinates[0] - i, start_coordinates[1] - i]
        end

        Piece.clear_out_of_bounds(all_moves)
      end 
    when 'queen'
      proc do |start_coordinates|
        all_moves = []
        0.upto(7) do |i|
          all_moves << [start_coordinates[0], i]
          all_moves << [i, start_coordinates[1]]
        end

        1.upto(7) do |i|
          all_moves << [start_coordinates[0] + i, start_coordinates[1] + i]
          all_moves << [start_coordinates[0] - i, start_coordinates[1] + i]
          all_moves << [start_coordinates[0] + i, start_coordinates[1] - i]
          all_moves << [start_coordinates[0] - i, start_coordinates[1] - i]
        end

        all_moves.delete(start_coordinates)
        Piece.clear_out_of_bounds(all_moves)      
      end
    when 'king'
      proc do |start_coordinates|
        all_moves = [[start_coordinates[0] + 1, start_coordinates[1] + 1],
                     [start_coordinates[0] + 1, start_coordinates[1]],
                     [start_coordinates[0] + 1, start_coordinates[1] - 1],
                     [start_coordinates[0], start_coordinates[1] + 1],
                     [start_coordinates[0], start_coordinates[1] - 1],
                     [start_coordinates[0] - 1, start_coordinates[1] + 1],
                     [start_coordinates[0] - 1, start_coordinates[1]],
                     [start_coordinates[0] - 1, start_coordinates[1] - 1]]

        Piece.clear_out_of_bounds(all_moves)
      end
    end
  end

  def self.clear_out_of_bounds(all_moves)
    all_moves.reject do |move_coordinates|
      move_coordinates[0] < 0 ||
      move_coordinates[0] > 7 ||
      move_coordinates[1] > 7 ||
      move_coordinates[1] < 0 
    end 
  end

  def initialize(colour, subclass)
    @colour = colour
    @subclass = subclass
    @possible_moves = Piece.get_moveset_proc(subclass, colour)
  end
end

# blackpawn = Piece.new("black", "pawn")
# p blackpawn.possible_moves.call([7,1])
# whitepawn = Piece.new("white","pawn")
# p whitepawn.possible_moves.call([0,1])
# rook = Piece.new("white", "rook")
# p rook.possible_moves.call([1,2])
# knight = Piece.new("white", "knight")
# p knight.possible_moves.call([3,4])
# bishop = Piece.new("white", "bishop")
# p bishop.possible_moves.call([1,1])
# queen = Piece.new("white", "queen")
# p queen.possible_moves.call([0,0])
# king = Piece.new("white", "king")
# p king.possible_moves.call([0,0])
