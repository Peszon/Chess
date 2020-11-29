# frozen_string_literal: true

# ./lib/board.rb

require_relative 'piece'
require_relative 'player'

require 'colorize'
require 'byebug'

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
  
  def check_move?(start_coordinates, end_coordinates) #seperating the helper methods in legal_moves and check_checks due to legal_moves need to be used in check_checks. 
    return true if legal_move?(start_coordinates, end_coordinates) #&& 
                   #check_checks?(start_coordinates, end_coordinates)
    false
  end 

  def legal_move?(start_coordinates, end_coordinates)
    return false unless check_move_in_bounds?(start_coordinates, end_coordinates)
    return true if check_start_and_end?(start_coordinates, end_coordinates) &&
                   check_jumping?(start_coordinates, end_coordinates) &&
                   check_piece_moves?(start_coordinates, end_coordinates) 
    false
  end

  def check_piece_moves?(start_coordinates, end_coordinates)
    possible_moves = @board[start_coordinates[0]][start_coordinates[1]].possible_moves.call(start_coordinates)
    return false unless possible_moves.include?(end_coordinates)
    true
  end 

  def check_move_in_bounds?(start_coordinates, end_coordinates)
    [start_coordinates, end_coordinates].each do |coordinates|
      return false if coordinates[0] < 0 || coordinates[0] > 7 || 
                      coordinates[1] < 0 || coordinates[1] > 7
    end 
    true
  end 

  def check_start_and_end?(start_coordinates, end_coordinates)
    return false if @board[start_coordinates[0]][start_coordinates[1]].nil? # there is no piece to move

    if @board[end_coordinates[0]][end_coordinates[1]].nil? # Checks that the moving piece is the same as the players whos turn it is. The end point has no piece and therefore no need to check it's color.
      return false if @board[start_coordinates[0]][start_coordinates[1]].color != @next_move.color 
    else #checks that the moving piece is the same color as the player and opposite of the piece it attacks. 
      return false if @board[start_coordinates[0]][start_coordinates[1]].color != @next_move.color || @board[end_coordinates[0]][end_coordinates[1]].color == @next_move.color
    end

    true
  end 

  def check_jumping?(start_coordinates, end_coordinates)
    row_dif = (end_coordinates[0] - start_coordinates[0])
    column_dif = (end_coordinates[1] - start_coordinates[1]) #gets the x and y differential between the current coordinates and the new ones

    return true if row_dif.abs < 2 && column_dif.abs < 2 # if the differental is less than 2 there is no possible way the piece could have jumped over another one. 

    row_dif == 0 ? row_increment = 0 : row_increment = (row_dif / row_dif.abs) #returns what the loop shall increment with 1, -1 or 0 depenting on the relation between the positions.
    column_dif == 0 ? column_increment = 0 : column_increment = (column_dif / column_dif.abs)

    row_index = start_coordinates[0] + row_increment
    column_index = start_coordinates[0] + column_increment
    while row_index != end_coordinates[0] && column_index != end_coordinates
      return false unless @board[row_index][column_index].nil? #checks that the squares between the two positons are empty. 
      row_index += row_increment
      column_index += column_increment
    end 

    true
  end 
 
end

#debugger 

board = Board.new
#board.board[2][0] = Piece.new("pawn", "black")
#board.board[1][1] = Piece.new("queen", "white")

# board.display
# board.move_piece([1,0],[3,0])
# board.display
# board.move_piece([6,0],[4,0])
# board.display
# board.next_move = 'black'
# p board
# puts ' '
# board.display
# print "\u2654".encode('utf-8').blue.colorize(:background => :white)
# print "this is blue".blue
# p board.board[1][1].possible_moves.call([1,1])
