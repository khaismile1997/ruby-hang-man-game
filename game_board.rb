require_relative 'input.rb'
require_relative 'display.rb'
require_relative 'read_txt.rb'
require 'yaml'
require 'pry-byebug'

class GameBoard
  include Input
  include Display
  include ReadTxt
  attr_accessor :key_word, :valid_letter, :correct_letter, :incorrect_letter, :lives

  def initialize(
    key_word = generate_kw,
    valid_letter = ('a'..'z').to_a,
    correct_letter = Array.new(key_word.length, "_"),
    incorrect_letter = Array.new,
    lives = 7
  )
    @key_word = key_word
    @valid_letter = valid_letter
    @correct_letter = correct_letter
    @incorrect_letter = incorrect_letter
    @lives = lives
  end

  def generate_kw
    file = File.open("5desk.txt")
    lib_words = file.readlines.map(&:chomp)
    file.close
    @key_word = lib_words.each(&:strip!).select{|w| w.length.between?(5,12)}.sample
  end

  def save_game
    Dir.mkdir 'saved' unless Dir.exist? 'saved'
    file_name = input_file_name(msg_hash[:save])
    file = File.open("saved/#{file_name}.yml", "w")
    file.write(save_to_yaml)
    file.close
    puts display_save_game_success(file_name)
  end

  def save_to_yaml  
    YAML.dump(
      "key_word" => @key_word,
      "valid_letter" => @valid_letter,
      "correct_letter" => @correct_letter,
      "incorrect_letter" => @incorrect_letter,
      "lives" => @lives
    )
  end

  def update_game_board(file_name)
    path = "saved/#{file_name}"
    file = YAML.load_file(path)
    @key_word = file['key_word']
    @valid_letter = file['valid_letter']
    @correct_letter = file['correct_letter']
    @incorrect_letter = file['incorrect_letter']
    @lives = file['lives']
    File.delete(path) if File.exist?(path)
  end

  def update_guess(guess)
    clear_screen
    @valid_letter -= [guess]
    if @key_word.include? guess
      tmp_kw = @key_word.split("")
      count = 0
      tmp_kw.each_with_index do |w, i|
        next unless w == guess
        @correct_letter[i] = guess
        count += 1
      end
      puts display_guess_correct(count) if @key_word != @correct_letter.join
    else
      @incorrect_letter.push(guess)
      @lives -= 1
      puts display_guess_incorrect(@lives) unless @lives.zero?
    end
  end

  def to_s
    rs = @correct_letter.join(".").blue + "\n\n"
    return rs if @lives == 7
    img = img_file("#{lives.to_s}_lives.txt")
    img + "\n" + rs
  end
end