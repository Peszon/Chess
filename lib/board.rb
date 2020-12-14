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

  def display_board
    if @next_move.color == 'white'
      7.downto(0) do |row_index|
        row = "#{row_index + 1} "

        0.upto(7) do |column_index|
          # p "#{row_index}:#{column_index}"
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

  def check_move?(start_coordinates, end_coordinates) # seperating the helper methods in legal_moves and check_checks due to legal_moves need to be used in check_checks.
    return false unless check_move_in_bounds?(start_coordinates, end_coordinates)

    if @board[start_coordinates[0]][start_coordinates[1]].subclass == 'pawn'
      return false unless check_pawn_taking_diagonally?(start_coordinates, end_coordinates) &&
                          check_pawn_moving_forward?(start_coordinates, end_coordinates)                          
                          #check_enpassant?(start_coordinates, end_coordinates)
    end
    return false unless check_start_and_end?(start_coordinates, end_coordinates) &&
                        check_jumping?(start_coordinates, end_coordinates) &&
                        check_piece_moves?(start_coordinates, end_coordinates) &&
                        check_checks?(start_coordinates, end_coordinates)

    true
  end

  def check_pawn_moving_forward?(start_coordinates, end_coordinates)
    if start_coordinates[1] - end_coordinates[1] != 0 
      return true
    else
      return true if @board[end_coordinates[0]][end_coordinates[1]].nil?
    end 

    false
  end
  
  def check_pawn_taking_diagonally?(start_coordinates, end_coordinates)
    if start_coordinates[1] - end_coordinates[1] == 0
      return true
    else 
      return true if @board[end_coordinates[0]][end_coordinates[1]]&.color != nil && @board[end_coordinates[0]][end_coordinates[1]]&.color != @next_move.color
    end

    false
  end 

  def check_piece_moves?(start_coordinates, end_coordinates)
    possible_moves = @board[start_coordinates[0]][start_coordinates[1]].possible_moves.call(start_coordinates)
    possible_moves.include?(end_coordinates) ? true : false
  end

  def check_move_in_bounds?(start_coordinates, end_coordinates)
    [start_coordinates, end_coordinates].each do |coordinates|
      return false if coordinates[0] < 0 || coordinates[0] > 7 ||
                      coordinates[1] < 0 || coordinates[1] > 7
    end
    true
  end

  def check_start_and_end?(start_coordinates, end_coordinates) # can be a bit wonky aswell
    return false if @board[start_coordinates[0]][start_coordinates[1]].nil? # there is no piece to move

    if @board[end_coordinates[0]][end_coordinates[1]].nil? # Checks that the moving piece is the same as the players whos turn it is. The end point has no piece and therefore no need to check it's color.
      return false if @board[start_coordinates[0]][start_coordinates[1]].color != @next_move.color
    else # checks that the moving piece is the same color as the player and opposite of the piece it attacks.
      if @board[start_coordinates[0]][start_coordinates[1]].color != @next_move.color || @board[end_coordinates[0]][end_coordinates[1]].color == @next_move.color
        return false
      end
    end

    true
  end

  def check_jumping?(start_coordinates, end_coordinates)
    row_dif = (end_coordinates[0] - start_coordinates[0])
    column_dif = (end_coordinates[1] - start_coordinates[1]) # gets the x and y differential between the current coordinates and the new ones

    if row_dif.abs < 2 && column_dif.abs < 2
      return true
    end # if the differental is less than 2 there is no possible way the piece could have jumped over another one.

    row_increment = row_dif == 0 ? 0 : (row_dif / row_dif.abs) # returns what the loop shall increment with 1, -1 or 0 depenting on the relation between the positions.
    column_increment = column_dif == 0 ? 0 : (column_dif / column_dif.abs)

    row_index = start_coordinates[0] + row_increment
    column_index = start_coordinates[1] + column_increment
    while row_index != end_coordinates[0] && column_index != end_coordinates[1]
      unless @board[row_index][column_index].nil?
        return false
      end # checks that the squares between the two positons are empty.

      row_index += row_increment
      column_index += column_increment
    end

    true
  end

  def check_checks?(start_coordinates, end_coordinates) # makes the move then checks every opposing piece to see if they can make a legal move that hits the king
    board_scenario = []
    @board.each_with_index do |row, _i|
      board_scenario << row.clone
    end

    board_scenario[end_coordinates[0]][end_coordinates[1]] = board_scenario[start_coordinates[0]][start_coordinates[1]]
    board_scenario[start_coordinates[0]][start_coordinates[1]] = nil

    king_coordinates = []
    board_scenario.each_with_index do |row, row_index|
      row.each_with_index do |piece, column_index|
        king_coordinates = [row_index, column_index] if piece&.subclass == 'king' && piece&.color == @next_move.color
      end
    end

    attacking_pieces = []
    board_scenario.each_with_index do |row, row_index|
      row.each_with_index do |piece, column_index|
        attacking_pieces << [row_index, column_index] if piece.is_a?(Piece) && piece&.color != @next_move.color
      end
    end

    attacking_pieces.each do |piece_info|
      if check_jumping?(piece_info, king_coordinates) && check_piece_moves?(piece_info, king_coordinates) && check_move_in_bounds?(piece_info, king_coordinates)
        return false
      end
    end

    true
  end

  def game_over?
    draw? || lost? ? true : false
  end

  def draw?
    @board.each_with_index do |row, _row_index|
      row.each_with_index do |piece, column_index|
      end
    end
  end
end
# debugger

board = Board.new

# board.check_checks?([1,1],[2,1])
# board.board[1][4] = nil
# board.board[1][3] = nil
# board.board[1][5] = nil
# board.board[1][6] = nil
# board.board[7][1] = nil
# board.board[7][7] = nil
# board.board[0][1] = nil
# board.board[0][7] = nil
# board.board[2][4] = Piece.new("rook", "black")
# board.next_move = (board.players.select { |players| players != board.next_move })[0]
#board.board[2][1] = Piece.new("pawn", "black")
p board.check_move_in_bounds?([1, 0], [2, 1])
p board.check_jumping?([1, 0], [2, 1])
p board.check_piece_moves?([1, 0], [2, 1])
p board.check_start_and_end?([1, 0], [2, 1])
p board.check_checks?([1, 0], [2, 1])
p board.check_pawn_moving_forward?([1, 0], [2, 1])
p board.check_pawn_taking_diagonally?([1, 0], [2, 1])
p board.check_move?([1, 0], [2, 1])
board.display_board
# board.board[0][7] = Piece.new("queen", "white")
# p board.board[0][7]

# board.board[2][0] = Piece.new("pawn", "black")
# board.board[1][1] = Piece.new("queen", "white")

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
