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
    @move_history = [[[9,9], [9,9], 32]]

    Board.setting_the_board(self)
  end

  def display_board
    if @next_move.color == 'white'
      7.downto(0) do |row_index|
        row = "#{row_index + 1} "

        0.upto(7) do |column_index|
          unless (@move_history[-1][0][0] == row_index && @move_history[-1][0][1] == column_index) || (@move_history[-1][1][0] == row_index && @move_history[-1][1][1] == column_index)
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
          else
            if @board[row_index][column_index].nil?
              row += '   '.colorize(background: :blue)
            else
              row += ' '.colorize(background: :blue) + @board[row_index][column_index].symbol.colorize(background: :blue) + ' '.colorize(background: :blue)
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
          unless (@move_history[-1][0][0] == row_index && @move_history[-1][0][1] == column_index) || (@move_history[-1][1][0] == row_index && @move_history[-1][1][1] == column_index)
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
          else
            if @board[row_index][column_index].nil?
              row += '   '.colorize(background: :blue)
            else
              row += ' '.colorize(background: :blue) + @board[row_index][column_index].symbol.colorize(background: :blue) + ' '.colorize(background: :blue)
            end
          end 
        end

        puts row
      end

      puts '   h  g  f  e  d  c  b  a'
    end
  end

  def move_piece(start_coordinates, end_coordinates)
    if @board[start_coordinates[0]][start_coordinates[1]]&.subclass == 'king' && (start_coordinates[1] - end_coordinates[1]).abs > 1
      if @next_move.color == 'white'
        if start_coordinates[1] > end_coordinates[1]
          @board[0][0] = nil
          @board[0][1] = nil
          @board[0][2] = Piece.new('king', 'white')
          @board[0][3] = Piece.new('rook', 'white')
          @board[0][4] = nil
        else
          @board[0][4] = nil
          @board[0][5] = Piece.new('rook', 'white')
          @board[0][6] = Piece.new('king', 'white')
          @board[0][7] = nil
        end
      else
        if start_coordinates[1] > end_coordinates[1]
          @board[7][0] = nil
          @board[7][1] = nil
          @board[7][2] = Piece.new('king', 'black')
          @board[7][3] = Piece.new('rook', 'black')
          @board[7][4] = nil
        else
          @board[7][4] = nil
          @board[7][5] = Piece.new('rook', 'black')
          @board[7][6] = Piece.new('king', 'black')
          @board[7][7] = nil
        end
      end
    else
      @board[end_coordinates[0]][end_coordinates[1]] = @board[start_coordinates[0]][start_coordinates[1]]
      @board[start_coordinates[0]][start_coordinates[1]] = nil
    end

    amount_of_pieces = 0
    @board.each { |row| row.each { |piece| amount_of_pieces += 1 if piece.is_a?(Piece) } }
    @move_history << [start_coordinates, end_coordinates, amount_of_pieces]

    promotion

    @next_move = @players.reject { |player| player == @next_move }
    @next_move = @next_move[0]
  end

  def promotion
    if @next_move.color == 'white'
      promotion_coordinate = nil
      @board[7].each_with_index { |piece, index| promotion_coordinate = index if piece&.subclass == 'pawn' }

      unless promotion_coordinate.nil?
        case @next_move.ask_for_promotion
        when 1
          @board[7][promotion_coordinate] = Piece.new('queen', 'white')
        when 2
          @board[7][promotion_coordinate] = Piece.new('rook', 'white')
        when 3
          @board[7][promotion_coordinate] = Piece.new('bishop', 'white')
        when 4
          @board[7][promotion_coordinate] = Piece.new('knight', 'white')
        end
      end
    else
      promotion_coordinate = nil
      @board[0].each_with_index { |piece, index| promotion_coordinate = index if piece&.subclass == 'pawn' }

      unless promotion_coordinate.nil?
        case @next_move.ask_for_promotion
        when 1
          @board[0][promotion_coordinate] = Piece.new('queen', 'black')
        when 2
          @board[0][promotion_coordinate] = Piece.new('rook', 'black')
        when 3
          @board[0][promotion_coordinate] = Piece.new('bishop', 'black')
        when 4
          @board[0][promotion_coordinate] = Piece.new('knight', 'black')
        end
      end
    end
  end

  def check_move?(start_coordinates, end_coordinates) # seperating the helper methods in legal_moves and check_checks due to legal_moves need to be used in check_checks.
    unless check_move_in_bounds?(start_coordinates, end_coordinates) && !@board[start_coordinates[0]][start_coordinates[1]].nil?
      return false
    end

    return false unless check_start_and_end?(start_coordinates, end_coordinates) &&
                        check_piece_moves?(start_coordinates, end_coordinates) &&
                        check_checks?(start_coordinates, end_coordinates)

    if @board[start_coordinates[0]][start_coordinates[1]].subclass == 'pawn'
      return false unless check_pawn_moves?(start_coordinates, end_coordinates)
    end

    if @board[start_coordinates[0]][start_coordinates[1]].subclass == 'king'
      return false unless check_castling?(start_coordinates, end_coordinates)
    end

    unless @board[start_coordinates[0]][start_coordinates[1]].subclass == 'knight'
      return false unless check_jumping?(start_coordinates, end_coordinates)
    end

    true
  end

  def check_castling?(start_coordinates, end_coordinates)
    return true if (start_coordinates[1] - end_coordinates[1]).abs < 2
    return false if @move_history.length < 1

    if @next_move.color == 'white'
      if start_coordinates[1] - end_coordinates[1] > 0
        if @board[0][3].nil? && @board[0][2].nil? && @board[0][1].nil? && check_checks? && check_checks?([0, 4], [0, 3]) && check_checks?([0, 4], [0, 2])
          @move_history.each do |move|
            return false if move.include?([0, 0]) || move.include?([0, 4])
          end

          return true
        end
      else
        if @board[0][5].nil? && @board[0][6].nil? && check_checks? && check_checks?([0, 4], [0, 5]) && check_checks?([0, 4], [0, 6])
          @move_history.each do |move|
            return false if move.include?([0, 7]) || move.include?([0, 4])
          end

          return true
        end
      end
    else
      if start_coordinates[1] - end_coordinates[1] > 0
        if @board[7][3].nil? && @board[7][2].nil? && @board[7][1].nil? && check_checks? && check_checks?([7, 4], [7, 3]) && check_checks?([7, 4], [7, 2])
          @move_history.each do |move|
            return false if move.include?([7, 0]) || move.include?([7, 4])
          end

          return true
        end
      else
        if @board[7][5].nil? && @board[7][6].nil? && check_checks? && check_checks?([7, 4], [7, 5]) && check_checks?([7, 4], [7, 6])
          @move_history.each do |move|
            return false if move.include?([7, 7]) || move.include?([7, 4])
          end

          return true
        end
      end
    end

    false
  end

  def check_pawn_moves?(start_coordinates, end_coordinates)
    check_pawn_moving_forward?(start_coordinates, end_coordinates) &&
    check_pawn_taking_diagonally?(start_coordinates, end_coordinates) &&
    check_pawn_two_steps?(start_coordinates, end_coordinates)
  end

  def check_pawn_moving_forward?(start_coordinates, end_coordinates)
    if start_coordinates[1] - end_coordinates[1] != 0
      return true
    else
      return false unless @board[end_coordinates[0]][end_coordinates[1]].nil?
    end

    true
  end

  def check_pawn_taking_diagonally?(start_coordinates, end_coordinates) # also include a check for en-passant
    return true if start_coordinates[1] - end_coordinates[1] == 0
    return false if start_coordinates[1] - end_coordinates[1] != 0 && @move_history.length < 2

    if @board[end_coordinates[0]][end_coordinates[1]]&.color == @next_move.color
      return false
    elsif @board[end_coordinates[0]][end_coordinates[1]].nil? && @board[@move_history[-1][1][0]][@move_history[-1][1][1]]&.subclass == 'pawn'
      if @next_move.color == 'white'
        if @move_history[-1][0][0] == 6 && @move_history[-1][1][0] == 4 && @move_history[-1][1][1] == end_coordinates[1] && end_coordinates[0] == 5
          @board[4][end_coordinates[1]] = nil
          return true
        end 
      else
        if @move_history[-1][0][0] == 1 && @move_history[-1][1][0] == 3 && @move_history[-1][1][1] == end_coordinates[1] && end_coordinates[0] == 2
          @board[3][end_coordinates[1]] = nil
          return true
        end 
      end
    elsif @board[end_coordinates[0]][end_coordinates[1]].nil?
      return false
    end

    true
  end

  def check_pawn_two_steps?(start_coordinates, end_coordinates)
    return true if (start_coordinates[0] - end_coordinates[0]).abs < 2

    if @board[start_coordinates[0]][start_coordinates[1]]&.color == 'white'
      unless start_coordinates[0] == 1 && @board[start_coordinates[0] + 1][start_coordinates[1]].nil? && @board[start_coordinates[0] + 2][start_coordinates[1]].nil?
        return false
      end
    else
      unless start_coordinates[0] == 6 && @board[start_coordinates[0] - 1][start_coordinates[1]].nil? && @board[start_coordinates[0] - 2][start_coordinates[1]].nil?
        return false
      end
    end

    true
  end

  def check_piece_moves?(start_coordinates, end_coordinates)
    possible_moves = @board[start_coordinates[0]][start_coordinates[1]].possible_moves.call(start_coordinates)
    possible_moves.include?(end_coordinates)
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
    else # checks that the moving piece is the same color as the player and opposite of the piece it attacks.
      if @board[start_coordinates[0]][start_coordinates[1]].color != @next_move.color || @board[end_coordinates[0]][end_coordinates[1]].color == @next_move.color
        return false
      end
    end

    true
  end

  def check_jumping?(start_coordinates, end_coordinates, board = @board)
    row_dif = (end_coordinates[0] - start_coordinates[0])
    column_dif = (end_coordinates[1] - start_coordinates[1]) # gets the x and y differential between the current coordinates and the new ones

    if row_dif.abs < 2 && column_dif.abs < 2
      return true
    end # if the differental is less than 2 there is no possible way the piece could have jumped over another one.

    row_increment = (row_dif == 0 ? 0 : (row_dif / row_dif.abs)) # returns what the loop shall increment with 1, -1 or 0 depenting on the relation between the positions.
    column_increment = (column_dif == 0 ? 0 : (column_dif / column_dif.abs))

    row_index = start_coordinates[0] + row_increment
    column_index = start_coordinates[1] + column_increment

    while row_index != end_coordinates[0] || column_index != end_coordinates[1]
      unless board[row_index][column_index].nil?
        return false
      end # checks that the squares between the two positons are empty.

      row_index += row_increment
      column_index += column_increment
    end

    true
  end

  def check_checks?(start_coordinates = nil, end_coordinates = nil) # makes the move then checks every opposing piece to see if they can make a legal move that hits the king
    board_scenario = []
    @board.each do |row|
      board_scenario << row.clone
    end

    unless start_coordinates.nil? || end_coordinates.nil?
      board_scenario[end_coordinates[0]][end_coordinates[1]] = board_scenario[start_coordinates[0]][start_coordinates[1]]
      board_scenario[start_coordinates[0]][start_coordinates[1]] = nil
    end

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
      unless check_piece_moves?(piece_info, king_coordinates) && check_move_in_bounds?(piece_info, king_coordinates)
        next
      end

      if board_scenario[piece_info[0]][piece_info[1]].subclass == 'pawn'
        return false if check_pawn_moves?(piece_info, king_coordinates)
      end
      return false if board_scenario[piece_info[0]][piece_info[1]].subclass == 'knight'
      return false if check_jumping?(piece_info, king_coordinates, board_scenario)
    end

    true
  end

  def game_over?
    draw? || lost? ? true : false
  end

  def draw?
    if @move_history.length >= 100
      return true if @move_history[-100][2] == @move_history[-1][2]
    end

    moveable_pieces = []
    @board.each_with_index do |row, row_index|
      row.each_with_index do |piece, column_index|
        moveable_pieces << [row_index, column_index] if piece&.color == @next_move.color
      end
    end

    piece_moves = moveable_pieces.map { |piece| @board[piece[0]][piece[1]].possible_moves.call([piece[0], piece[1]]) }
    piece_moves.each_with_index do |moves, start_index|
      return false if moves.any? { |move| check_move?(moveable_pieces[start_index], move) }
    end

    true
  end

  def lost?
    draw? && !check_checks? ? true : false
  end
end
