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

  def save_game(board_state, move_history)
    json_hash = [board_state, move_history].to_json
    File.open("saved_games.txt", "a") do |file| 
      file.puts json_hash
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
      
      json_hash = retrive_game_from_file(players_choice.to_i)
      JSON.parse(jon_hash)
    end
  end

  def display_all_saved_games
    all_game = file.readlines
    File.open("sved_games.txt", "r") do |file|
      puts all_games
      all_games.each_with_index do |game, index|
        attribute_hash = JSON.parse(game) 
        puts "game #{index + 1}, word: #{attribute_hash["save_profile"]}, guessed letters: #{attribute_hash["guessed_letters"].join(", ")}"
      end 
    end
  end
  
  def number_of_games 
    File.open("saved_games.txt","r") { |file| return file.readlines.size }
  end    

  def retrive_game_from_file(row)
    json_hash = nil
    File.open("saved_games.txt", "r") do |file|
      while row > 0
        row -= 1
        json_hash = file.gets
      end
    end
         
    json_hash
  end 
end 