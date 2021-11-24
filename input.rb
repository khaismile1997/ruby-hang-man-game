module Input
  def msg_hash
    {
      ready: "Are you ready? (y or n): ",
      win:   "\nCongratulations, you're still alive!".green,
      lose:  "\nSorry, you #{"death".upcase.red}. Better luck next time!",
      continue: "Would you like to play a new game? (y or n): ",
      again: "Would you like to play again? (y or n): ",
      save: "Please enter a name to remember: ",
      load: "Please enter index follow your game name \n or type 'back' to back to select options screen: ",
      file_not_exist: "No games have been saved yet! Please play new game.",
      bye:   "Thanks for playing! Goodbye."
    }
  end

  def yes_no(msg)
    print msg
    ans = gets.chomp[0]
    ans.downcase!
    
    until %w(y n).include? ans
      puts "Please enter 'y' or 'n'."
      print msg
      ans = gets.chomp[0]
      ans.downcase!
    end
    ans
  end
  
  def input_number_in_range(msg, range)
    print msg
    number = gets.chomp.to_i
    until range.include? number
      puts "Number must between #{range.first} & #{range.last}, inclusive."
      print msg
      number = gets.chomp.to_i
    end
    number
  end

  def input_each_turn(msg, valid_letter)
    print msg
    intention = gets.chomp
    until valid_letter.include?(intention) || ['save', 'exit'].include?(intention)
      print "Letter not available or already guessed.\n".red
      print msg
      intention = gets.chomp
    end
    intention
  end
  
  def input_file_name(msg)
    print msg
    serial = gets.chomp
    until serial.match?(/^[\w\-. ]+$/)
      print "Filename must not contain special characters!!!\n"
      print msg
      serial = gets.chomp
    end
    serial
  end

  def input_load_file(msg, max)
    print msg
    selection = gets.chomp
    until selection.match?(/[1-#{max}]/) || selection == 'back'
      puts "Invalid selection!"
      print msg
      selection = gets.chomp
    end
    selection
  end 
end