# frozen_string_literal: true

# ./lib/game.rb

require_relative 'board'

require 'byebug'

class Game
  def initialize
    start_up
    game_loop
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
                      -----------------------------------------
    HEREDOC
    print start_up_message

    answer = gets.chomp
    until ["1","2"].include?(answer)
      system('clear')
      print start_up_message
      answer = gets.chomp 
    end

    if answer == "1"
      @board = Board.new
    else
      #load_game
    end 
  end

  def game_loop
    until @board.game_over?
      system('clear')
      @board.display_board
      next_move = @board.next_move.ask_for_move
      until @board.check_move?(next_move[0], next_move[1])
        system('clear')
        @board.display_board
        next_move = @board.next_move.ask_for_move 
      end 

      @board.move_piece(next_move[0], next_move[1])
    end 
  end 
end

Game.new