# frozen_string_literal: true

# ./lib/game.rb

require_relative 'board'
require_relative 'game_manager'

require 'byebug'

class Game
  def initialize
    start_up
  end

  def start_up
    system('clear')
    start_up_message = <<~'HEREDOC'
                        _____ _                   _ 
                       / ____| |                 | |
                      | |    | |__   ___  ___ ___| |
                      | |    |  _ \ / _ \/ __/ __| |
                      | |____| | | |  __/\__ \__ \_|
                       \_____|_| |_|\___||___/___(_)
                      -----------------------------------------
                      (1): New game
                      (2): Load game
                      (3): Quit
                      -----------------------------------------
    HEREDOC
    print start_up_message

    answer = gets.chomp
    until ["1", "2", "3"].include?(answer)
      system('clear')
      print start_up_message
      answer = gets.chomp 
    end

    if answer == "1"
      @board = Board.new
      game_loop
    elsif answer == "2"
      @board = Board.new
      load_game
      game_loop
    else
      nil
    end
  end

  def game_loop
    until @board.game_over?
      system('clear')
      @board.display_board
      next_move = @board.next_move.ask_for_move

      if next_move == "save"
        save_game
        start_up
        break
      end

      until @board.check_move?(next_move[0], next_move[1]) 
        system('clear')
        @board.display_board
        next_move = @board.next_move.ask_for_move 
      end 

      @board.move_piece(next_move[0], next_move[1])
    end 
  end 

  def save_game
    board_state = @board.board.map do |row|
      new_row = row.map do |piece|
        if piece.nil?
          nil
        else
          [piece.subclass, piece.color]
        end
      end 
    end 

    Game_manager.new.save_game(board_state, @board.move_history, @board.next_move.color)
  end 
end

def load_game
  game_array = Game_manager.new.load_game
  @board.board = game_array[1]

  @board.board.map! do |row|
    row.map! do |piece|
      if piece.nil?
        nil
      else
        Piece.new(piece[0], piece[1])
      end 
    end 
  end
  
  @board.move_history = game_array[2]
  @board.next_move = Player.new(game_array[3])
end 

Game.new