# frozen_string_literal: true

require_relative 'color'
require_relative 'database'
require_relative 'display'
require 'yaml'
require 'pry-byebug'

# A class for basic logic of the game
class Hangman
  include Database
  include Display

  def initialize
    @secret_word = generate_word.downcase
    @key_clues = @secret_word.length.times.map { '_' }.join('')
    @correct_letters = []
    @incorrect_letters = []
    @remaining_guess = 10
    choose_game
  end

  def choose_game
    puts display_instructions.green
    game_type = user_input(display_start.blue, /^[12]/)
    play_game if game_type == '1'
    load_game if game_type == '2'
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      input.match(regex) ? (return input) : puts(display_input_warning)
    end
  end

  def play_game
    puts display_new_random_word
    puts display_turn_prompt
    loop do
      player_turn
      print 'Please enter your guess in one letter: '.blue
      guess = gets.chomp

      save_game if guess == 'save'

      filter_guess(guess.downcase)

      break if game_over || game_solved || guess == 'save' || guess == 'exit'
    end
  end

  def filter_guess(guess)
    return puts "Invalid input: #{guess}" if guess.match(/[^a-z]/) || guess.length.zero?
    return puts "\nYou've already guessed that letter!".red if guessed_letter?(guess)
    return puts 'Thank you for playing Hangman!' if guess.include?('save') || guess.include?('exit')

    enter_guess(guess)
  end

  def guessed_letter?(guess)
    @correct_letters.include?(guess) || @incorrect_letters.include?(guess)
  end

  def game_over
    return unless @remaining_guess.zero?

    puts "Unfortunately, you couldn't guess the word :(".red
    puts "#{@secret_word}\n".cyan
    true
  end

  def game_solved
    return unless @secret_word == @key_clues

    puts 'You guessed the word!'.green
    puts "#{@secret_word}\n".cyan
    true
  end

  def player_turn
    if @remaining_guess < 10
      print 'Incorrect letters: '.magenta
      @incorrect_letters.each { |guess| print "#{guess} ".magenta }
    end
    puts "\nIncorrect guesses remaining: #{@remaining_guess}".cyan if @remaining_guess > 1
    puts "\nBe careful! It's only #{@remaining_guess} chances left!".yellow if @remaining_guess <= 3

    puts @key_clues
  end

  def enter_guess(char)
    return puts "\nGood move!\n".green if correct_guess?(char)

    puts "\nSorry, that's not included\n".red
  end

  def correct_guess?(char)
    if @secret_word.include?(char)
      @correct_letters << char
      add_clue(char)
      true
    else
      @incorrect_letters << char
      @remaining_guess -= 1
      false
    end
  end

  def add_clue(char)
    @secret_word.split('').each_with_index do |v, i|
      @key_clues[i] = char if v == char
    end
  end

  def generate_word
    text_file = File.open('5desk.txt', 'r')
    words = []
    text_file.each_line do |word|
      word = word.chomp
      words << word if word.length <= 12 && word.length >= 5
    end
    text_file.close
    words.sample
  end
end
