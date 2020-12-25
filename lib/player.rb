# frozen_string_literal: true

# ./lib/piece.rb

require 'byebug'

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def ask_for_move
    puts "#{@color}: what piece would you like to move?"
    start_coordinates = get_move

    return 'save' if start_coordinates == 'save'

    puts "#{@color}: where would you like to move it?"
    end_coordinates = get_move

    [start_coordinates, end_coordinates]
  end

  def get_move
    numbers = ('1'..'8').to_a
    letters = ('a'..'h').to_a

    move = gets.chomp
    return 'save' if move == 'save'

    until move.length == 2 && letters.include?(move[0]) && numbers.include?(move[1])
      puts "#{@color}: incorrect input format; column first row second (e4, h6 or a2)"
      move = gets.chomp
    end

    [move[1].to_i - 1, letters.index(move[0])]
  end

  def ask_for_promotion
    puts "#{@color}: You can promote a pawn on the last rank!"
    puts "#{@color}: What would you like to promote it to?"
    puts "#{@color}: Press 1 for queen"
    puts "#{@color}: Press 2 for rook"
    puts "#{@color}: Press 3 for bishop"
    puts "#{@color}: Press 4 for knight"

    promotion_choice = gets.chomp
    promotion_choice = gets.chomp until %w[1 2 3 4].include?(promotion_choice)
    promotion_choice
  end
end
