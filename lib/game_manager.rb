# frozen_string_literal: true

# ./lib/game_manager.rb

require 'json'

class Game_manager
  def self.create_load_file
    if !File.file?('saved_games.txt')
      File.open('saved_game.txt', 'w') { |file| file.rewind }
    end 
  end 

  def initalize
    Game_manager.create_load_file
  end 

  def save_game(board_state, move_history, next_move_color)
    game_array = [Time.now.strftime("%Y/%m/%d - %k%M"), board_state, move_history, next_move_color].to_json
    File.open("saved_games.txt", "a") do |file| 
      file.puts game_array
    end 
  end 

  def load_game  
    if File.size?("saved_games.txt").nil?
      puts "there are no saved files, please starting a new game instead!"
      
      nil
    else
      display_all_saved_games
      num_games = number_of_games 
      
      puts "please choose a game: "

      players_choice = gets.chomp
      loop do
        break if (1..num_games).include?(players_choice.to_i) 
        puts "please enter a number that corresponds to a game!" 
        players_choice = gets.chomp
      end
      
      game_array = retrive_game_from_file(players_choice.to_i)
      JSON.parse(game_array)
    end
  end

  def display_all_saved_games
    File.open("saved_games.txt", "r") do |file|
      all_games = file.readlines
      all_games.each_with_index do |game, index|
        game_array = JSON.parse(game) 
        puts "game: #{index + 1}, save_date: #{game_array[0]}, moves: #{game_array[2].length - 1}, next_move: #{game_array[3]}"
      end 
    end
  end
  
  def number_of_games 
    File.open("saved_games.txt","r") { |file| return file.readlines.size }
  end    

  def retrive_game_from_file(row)
    game_array = nil
    File.open("saved_games.txt", "r") do |file|
        game_array = file.gets
      end
    end
         
    game_array
  end 
end 