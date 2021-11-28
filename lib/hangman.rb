require_relative 'color'

class Hangman
  def initialize
    @secret_word = generate_word.downcase
    @key_clues = ''
    @secret_word.length.times { @key_clues << '_' }
    puts @secret_word
    @correct_letters = []
    @incorrect_letters = []
    @remaining_guess = 10
  end

  def play_game
    loop do
      turn_order
      print 'Please enter your guess in one letter: '.blue
      guess = gets.chomp
      if /[^a-z]/.match(guess) || guess.length > 1 || guess.length.zero?
        puts "Invalid input: #{guess}".red
        break
      end

      check_guess(guess.downcase)

      break if game_over || game_solved
    end
  end

  def check_guess(guess)
    if @correct_letters.include?(guess) || @incorrect_letters.include?(guess)
      puts "\nYou've already guessed that letter!".red
    else
      enter_guess(guess)
    end
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

  def turn_order
    if @remaining_guess < 10
      print 'Incorrect letters: '.magenta
      @incorrect_letters.each { |guess| print "#{guess} ".magenta }
    end
    if @remaining_guess > 1
      puts "\nIncorrect guess remaining: #{@remaining_guess}".cyan
    else
      puts 'Last chance!'.red
    end
    puts @key_clues
  end

  def enter_guess(char)
    if @secret_word.include?(char)
      @correct_letters << char
      add_clue(char)
      puts "\nGood move!\n".green
    else
      @incorrect_letters << char
      @remaining_guess -= 1
      puts
      puts "Sorry, that's not included\n".red
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
