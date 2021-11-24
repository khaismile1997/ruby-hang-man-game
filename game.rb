require_relative 'display.rb'
require_relative 'input.rb'
require_relative 'read_txt.rb'

class Game
  include Input
  include Display
  include ReadTxt

  attr_reader :game_board

  def initialize
    clear_screen
    puts img_file("title.txt").green
    puts introduce
  end

  def play_game
    playing = yes_no(msg_hash[:ready]) == 'y'
    while playing
      clear_screen
      start_game
      playing = continue?(msg_hash[:again])
    end
    puts msg_hash[:bye]
  end

  def start_game
    game_setup
    next_turn until game_over?
    puts game_over?
  end

  def game_setup
    msg = display_start
    game_mode = input_number_in_range(msg, (1..2).to_a)

    if game_mode.eql? 1
      new_game
    else
      load_game
    end
  end

  def new_game
    clear_screen
    @game_board = GameBoard.new
  end

  def load_game
    clear_screen
    file_list = Dir.children("saved").map{|name| name}
    if file_list.empty?
      puts msg_hash[:file_not_exist]
      return start_game
    end
    puts display_saved_game("#", "File name")
    file_list.each_with_index do |name, i|
      puts display_saved_game(i+1, name)
    end
    selection = input_load_file(msg_hash[:load], file_list.length)
    case selection
    when 'back'
      clear_screen
      game_setup
    else
      file_name = file_list[selection.to_i-1]
      @game_board = GameBoard.new
      game_board.update_game_board(file_name)
    end
  end

  def next_turn
    puts game_board
    msg = display_each_turn(game_board)
    intention = input_each_turn(msg, game_board.valid_letter)

    case intention
    when 'exit'
      print msg_hash[:bye] + "\n"
      exit 1
    when 'save'
      game_board.save_game
      if continue?(msg_hash[:continue])
        clear_screen
        start_game
      else
        print msg_hash[:bye] + "\n"
        exit 1
      end
    else
      game_board.update_guess(intention)
    end
  end

  def continue?(msg)
    yes_no(msg) == 'y'
  end

  def game_over?
    if !game_board.lives.zero? && game_board.correct_letter.join == game_board.key_word
      return img_file("victory.txt") + msg_hash[:win] + "\n" + "Keyword is: #{game_board.key_word.yellow}"
    end
    return img_file("game_over.txt") + msg_hash[:lose] if game_board.lives.zero?

    false
  end
end