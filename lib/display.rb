module Display
  def display_instructions
    <<~HEREDOC
      Welcome to Hangman game!

      Here is the rule of this game:

      A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. To win, you must find all the letters in the word with 10 chances for incorrect guesses.

    HEREDOC
  end

  def display_start
    <<~HEREDOC
      Let's play Hangman in the console! Would you like to:
      \e[33m[1]\e[0m Play a new game
      \e[33m[2]\e[0m Load a saved game
    HEREDOC
  end

  def display_new_random_word
    <<~HEREDOC
      \e[34mYour random word has been chosen, it has #{@secret_word.length} letters.\e[0m

    HEREDOC
  end

  def display_turn_prompt
    <<~HEREDOC
      Your turn to guess one letter in the secret word.
      You can also type 'save' or 'exit' to leave the game.
    HEREDOC
  end

  def display_input_warning
    <<~HEREDOC
      \e[31mSorry, that is an invalid answer. Please, try again.\e[0m
    HEREDOC
  end

  def display_saved_prompt
    <<~HEREDOC

      Enter the game \e[34m[#]\e[0m that you would like to play.
      You can also type 'exit' to leave the game.

    HEREDOC
  end

  def display_saved_games
    <<~HEREDOC

      Here is the list of your saved games:
    HEREDOC
  end

  def display_list_saved_game(number, name)
    <<~HEREDOC

      \e[34m[#{number}]\e[0m #{name}
    HEREDOC
  end
end
