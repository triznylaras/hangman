puts 'Hangman initialized.'

text_file = File.read('5desk.txt')

words = []
text_file.each_line do |word|
  # puts word
  if word.length <= 12 && word.length >= 5
    /[[:lower:]]/.match(word[0])
    words << word
  end
end

puts words.sample