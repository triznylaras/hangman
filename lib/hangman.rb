class Hangman

  def initialize
    @secret_word = generate_word
    @key_clues = ''
    @secret_word.length.times { @key_clues << '_' }
    puts @secret_word
    @solved_letters = []
    @incorrect_letters = []
    turn_order(@secret_word)
  end

  def turn_order(secret_word)
    begin
      puts 'Please enter your guess in one letter'
      guess = gets.chomp
      raise "Invalid input: #{guess}" unless /[[:alpha:]]/.match(guess) && guess.length == 1
      
      enter_guess(guess.downcase)
    rescue StandardError => e
      puts e.to_s
      retry
    end
  end

  def enter_guess(char)
    if @secret_word.include?(char)
      @solved_letters << char
      add_clue(char)
      puts
      puts 'Good move!'
    else
      @incorrect_letters << char
      puts
      puts "Sorry that's not included"
    end
  end

  def add_clue(char)
    @secret_word.split('').each_with_index do |v, i|
      @key_clues[i] = char if v == char
    end
  end

  # puts 'Hangman initialized.'

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