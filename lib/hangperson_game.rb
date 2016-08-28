class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = "-" * @word.length
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(char)
    raise ArgumentError if char == '' || char == '%' or char == nil
    char.downcase!
    if (@word.include? char) && !(@guesses.include? char)
      char_indexes = (0 .. @word.length).find_all {|i| @word[i] == char}
      char_indexes.each { |i| @word_with_guesses[i] = char }
      @guesses << char
    elsif  !(@wrong_guesses.include? char) && !(@guesses.include? char) 
      @wrong_guesses << char
    elsif (@wrong_guesses.include? char) || (@guesses.include? char)
      return false  
    end
    return true
  end 

  def check_win_or_lose
    if @word_with_guesses.include? "-" and @wrong_guesses.length >= 7
      return :lose
    elsif @word == @word_with_guesses
      return :win
    else
      return :play
    end
  end
end
