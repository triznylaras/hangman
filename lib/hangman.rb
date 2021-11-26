class Hangman

  def initialize
    @secret_word = generate_word
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
      print 'Please enter your guess in one letter: '
      guess = gets.chomp
      return "Invalid input: #{guess}" unless /[[:alpha:]]/.match(guess) && guess.length == 1
      
      enter_guess(guess.downcase)

      break if over?
    # rescue StandardError => e
    #   puts e.to_s
    #   retry
    end
  end

  def over?
    if @secret_word == @key_clues
      puts 'You guessed the word!'
      puts @secret_word
      puts
      turn_order
    elsif @remaining_guess.zero?
      puts "Unfortunately, you couldn't guess the word :("
      puts @secret_word
      puts
      true
    end
  end

  def turn_order
    if @remaining_guess < 10
      print "Incorrect letters: "
      @incorrect_letters.each { |guess| print guess.to_s + ' ' }
      puts
    end
    if @remaining_guess > 1
      puts "Incorrect guess remaining: #{@remaining_guess}"
    else
      puts "Last chance!"
    end
    puts @key_clues
  end

  def enter_guess(char)
    if @secret_word.include?(char)
      @correct_letters << char
      add_clue(char)
      puts
      puts 'Good move!'
    else
      @incorrect_letters << char
      @remaining_guess -= 1
      puts
      puts "Sorry that's not included"
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
      if word.length <= 12 &&
        word.length >= 5
        words << word
      end
    end
    text_file.close
    words.sample
  end
end