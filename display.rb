module Display
  def introduce
    <<~HEREDOC
    #{'Welcome to Hangman!'.bold.underline.italic.red}

    #{'How to play:'.underline.blue}

      * Try to find the secret word by guessing one letter at a time.
      * Each correct guess will reveal those letters in the secret word.
      * Guess incorrectly and lose a life.
      * If you lose all 7 lives - game over!

    #{'GOODLUCK!!!'.bold.yellow}
    HEREDOC
  end

  def display_start
    <<~HEREDOC
      Please choose game options:
      #{"[1]".blue} New game
      #{"[2]".blue} Load game
    HEREDOC
  end
  
  def display_each_turn(game_board)
    <<~HEREDOC
      The keyword you need to guess must contain #{game_board.key_word.length.to_s.yellow} letters.
      You guessed #{(game_board.correct_letter-["_"]).length.to_s.green} letters exactly.
      Letter guessed: #{('a'..'z').to_a-game_board.valid_letter}

      Please enter the letter you want to guess,
      #{'save'.blue} to save your game or #{'exit'.red} if you want to quit this game:
    HEREDOC
  end
  
  def display_save_game_success(file_name)
    <<~HEREDOC
      Your game is now saved. The name of this game is: #{file_name.blue}.
    HEREDOC
  end

  def display_saved_game(index, file_name)
    <<~HEREDOC
      #{index.to_s.blue} #{file_name.yellow}
    HEREDOC
  end

  def display_guess_correct(count)
    <<~HEREDOC
      "Congratulations, you're guessed correct #{count.to_s.green} letters!"
    HEREDOC
  end
  
  def display_guess_incorrect(lives)
    <<~HEREDOC
      "Sorry, you're guessed incorrect letters. You remains #{lives.to_s.red} lives left!"
    HEREDOC
  end

  def clear_screen
    system('clear') || system('cls')
  end
end
