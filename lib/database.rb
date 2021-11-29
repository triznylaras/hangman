module Database
  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    @filename = "#{random_name}_game.yaml"
    File.open("output/#{@filename}", 'w') { |file| file.write save_to_yaml }
    puts "Your game has been saved with name #{@filename}"
  end

  def save_to_yaml
    YAML.dump(
      'secret_word' => @secret_word,
      'correct_letters' => @correct_letters,
      'incorrect_letters' => @incorrect_letters
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
    file_list.each_with_index do |name, index|
      puts 'Here is the list of the saved game: '
      puts "#{index + 1}, #{name}"
    end
  end
end
