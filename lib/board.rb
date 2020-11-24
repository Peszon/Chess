# frozen_string_literal: true

# ./lib/board.rb

require_relative 'piece'
require_relative 'player'

require 'colorize'

class Board
  attr_accessor :board, :move_history, :next_move, :players

  def self.setting_the_board(board)
    board.board[0][0] = Piece.new('rook', 'white')
    board.board[0][1] = Piece.new('knight', 'white')
    board.board[0][2] = Piece.new('bishop', 'white')
    board.board[0][3] = Piece.new('queen', 'white')
    board.board[0][4] = Piece.new('king', 'white')
    board.board[0][5] = Piece.new('bishop', 'white')
    board.board[0][6] = Piece.new('knight', 'white')
    board.board[0][7] = Piece.new('rook', 'white')

    0.upto(7) do |column_index|
      board.board[1][column_index] = Piece.new('pawn', 'white')
      board.board[6][column_index] = Piece.new('pawn', 'black')
    end

    board.board[7][0] = Piece.new('rook', 'black')
    board.board[7][1] = Piece.new('knight', 'black')
    board.board[7][2] = Piece.new('bishop', 'black')
    board.board[7][3] = Piece.new('queen', 'black')
    board.board[7][4] = Piece.new('king', 'black')
    board.board[7][5] = Piece.new('bishop', 'black')
    board.board[7][6] = Piece.new('knight', 'black')
    board.board[7][7] = Piece.new('rook', 'black')
  end

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @players = [Player.new, Player.new]
    @next_move = 'white'
    @move_history = []

    Board.setting_the_board(self)
  end

  def display
    if @next_move == 'white'
      7.downto(0) do |row_index|
        row = "#{row_index + 1} "
        0.upto(7) do |column_index|
          if (row_index + column_index).even?
            row += ' '.colorize(background: :black) + "\u2656".encode('utf-8').colorize(background: :black) + ' '.colorize(background: :black)
          else
            row += ' '.colorize(background: :red) + "\u2656".encode('utf-8').colorize(background: :red) + ' '.colorize(background: :red)
          end
        end

        puts row
      end

      puts '   a  b  c  d  e  f  g  h'
    else
      0.upto(7) do |row_index|
        row = "#{row_index + 1} "
        7.downto(0) do |column_index|
					if (row_index + column_index).even?
						if @board[row_index][column_index].nil?
							row += '   '.colorize(background: :black)
						else 
							row += ' '.colorize(background: :black) + @board[row_index][column_index].symbol.colorize(background: :black) + ' '.colorize(background: :black)
						end 
					else
						if @board[row_index][column_index].nil?
							row += '   '.colorize(background: :red)
						else
							row += ' '.colorize(background: :red) + @board[row_index][column_index].symbol.colorize(background: :red) + ' '.colorize(background: :red)
						end 
          end
        end

        puts row
      end

      puts '   h  g  f  e  d  c  b  a'
    end
  end
end

# board = Board.new
# board.display
# board.next_move = 'black'
# p board
# puts ' '
# board.display
# print "\u2654".encode('utf-8').blue.colorize(:background => :white)
# print "this is blue".blue
# p board.board[1][1].possible_moves.call([1,1])
