# frozen_string_literal: true

# subclass of the piece is it's type "pawn", "knight", or "queen" e.v.

# ./lib/piece.rb

class Piece
  attr_reader :color, :subclass, :possible_moves, :symbol

  def self.get_moveset_proc(subclass, color)
    case subclass
    when 'pawn'
      if color == 'white'
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
                     [start_coordinates[0] - 1, start_coordinates[1] - 1],
                     [start_coordinates[0], start_coordinates[1] + 2],
                     [start_coordinates[0], start_coordinates[1] - 2]]
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

  def self.get_symbol(subclass, color)
    case subclass
    when "pawn"
      if color == "black"
        "\u2659"
      else
        "\u265F"
      end 
    when "rook"
      if color == "black"
        "\u2656"
      else
        "\u265C"
      end 
    when "bishop"
      if color == "black"
        "\u2657"
      else
        "\u265D"
      end 
    when "knight"
      if color == "black"
        "\u2658"
      else
        "\u265E"
      end 
    when "queen"
      if color == "black"
        "\u2655"
      else
        "\u265B"
      end 
    when "king"
      if color == "black"
        "\u2654"
      else
        "\u265A"
      end 
    end 
  end

  def initialize(subclass, color)
    @subclass = subclass
    @color = color
    @possible_moves = Piece.get_moveset_proc(subclass, color)
    @symbol = Piece.get_symbol(subclass, color)
  end
end
