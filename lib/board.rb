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
    @players = [Player.new('white'), Player.new('black')]
    @next_move = @players[0]
    @move_history = []

    Board.setting_the_board(self)
  end

  def display
    if @next_move.color == 'white'
      7.downto(0) do |row_index|
				row = "#{row_index + 1} "
				
				0.upto(7) do |column_index|
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

	def move_piece(start_coordinates, end_coordintes)
		@board[end_coordintes[0]][end_coordintes[1]] = @board[start_coordinates[0]][start_coordinates[1]]
		@board[start_coordinates[0]][start_coordinates[1]] = nil

		@move_history << [start_coordinates, end_coordintes]

		@next_move = @players.reject { |player| player == @next_move }
		@next_move = @next_move[0] 
	end 
end

board = Board.new
board.display
board.move_piece([1,0],[3,0])
board.display
board.move_piece([6,0],[4,0])
board.display
# board.next_move = 'black'
# p board
# puts ' '
# board.display
# print "\u2654".encode('utf-8').blue.colorize(:background => :white)
# print "this is blue".blue
# p board.board[1][1].possible_moves.call([1,1])
