# frozen_string_literal: true

# A module that contains function to save and load game files
module Database
  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    puts 'Enter name for the saved game, or blank to create random name: '
    file_name = gets.chomp
    file_name = random_name if file_name == ''
    @filename = "#{file_name}_game.yaml"
    File.open("output/#{@filename}", 'w') { |file| file.write save_to_yaml }
    puts "Your game has been saved with name #{@filename}"
  end

  def save_to_yaml
    YAML.dump(
      'secret_word' => @secret_word,
      'correct_letters' => @correct_letters,
      'incorrect_letters' => @incorrect_letters,
      'key_clues' => @key_clues,
      'remaining_guess' => @remaining_guess
    )
  end

  def random_name
    adjective = %w[red best dark fun blue cold last tiny new pink]
    nouns = %w[car hat star dog tree foot cake moon key rock]
    "#{adjective[rand(0 - 9)]}_#{nouns[rand(0 - 9)]}_#{rand(11..99)}"
  end

  def file_list
    files = []
    Dir.entries('output').each do |name|
      files << name if name.match(/(game)/)
    end
    files
  end

  def show_file_list
    puts display_saved_games
    file_list.each_with_index do |name, index|
      puts display_list_saved_game((index + 1).to_s, name.to_s)
    end
  end

  def load_game
    find_saved_file
    load_saved_file
    play_game
  end

  def find_saved_file
    show_file_list
    file_number = user_input(display_saved_prompt, /\d+|^exit$/)
    @saved_game = file_list[file_number.to_i - 1] unless file_number == 'exit'
  end

  def load_saved_file
    file = YAML.safe_load(File.read("output/#{@saved_game}"))
    @secret_word = file['secret_word']
    @correct_letters = file['correct_letters']
    @incorrect_letters = file['incorrect_letters']
    @key_clues = file['key_clues']
    @remaining_guess = file['remaining_guess']
  end
end
