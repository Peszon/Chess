# frozen_string_literal: true
# subclass of the piece is it's type "pawn", "knight", or "queen" e.v.

# ./lib/piece.rb

class Piece
  attr_reader :colour, :subclass, :possible_moves

  def self.get_moveset_proc(subclass)
    case subclass
    when "pawn"
      return proc do |start_coordinates|
        [[start_coordinates[0] + 1, start_coordinates[1] - 1], 
         [start_coordinates[0] + 1, start_coordinates[1]], 
         [start_coordinates[0] + 1, start_coordinates[1] + 1]]
      end 
    when "rook"
      return proc do |start_coordinates|
        all_moves = []
        0.upto(7) do |index|
          all_moves << [start_coordinates[0], index]
          all_moves << [index, start_coordinates[1]]
        end 
        all_moves.reject { |move_coordinates| start_coordinates == move_coordinates }
      end 
    when "knight"
      return proc do |start_coordinates|
        [[start_coordinates[0] + 2, start_coordinates[1] + 1],
         [start_coordinates[0] + 2, start_coordinates[1] - 1],
         [start_coordinates[0] + 1, start_coordinates[1] + 2],
         [start_coordinates[0] + 1, start_coordinates[1] - 2],
         [start_coordinates[0] - 1, start_coordinates[1] + 2],
         [start_coordinates[0] - 1, start_coordinates[1] - 2],
         [start_coordinates[0] - 2, start_coordinates[1] + 1],
         [start_coordinates[0] - 2, start_coordinates[1] - 1]]
      end 
    when "bishop"
      return proc do |start_coordinates|
        all_moves = []
        1.upto(7) do |index|
          # lägga till eller ta bort på båda sidorna eller ta bort och lägga till på de båda sidorna samtidigt      
        end 
        all_moves.reject { |move_coordinates| move_coordinates[0] < 0 || 
                                              move_coordinates[0] > 7 || 
                                              move_coordinates[1] > 7 || 
                                              move_coordinates[1] < 0 }
      end 
    when "queen"
    when "king"
    end 
  end

  def initialize(colour, subclass)
    @colour = colour
    @subclass = subclass
    @possible_moves = Piece.get_moveset_proc(subclass)
  end
end
