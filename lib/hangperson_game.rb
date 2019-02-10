class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.length
  end

  def guess(letter)
    letter = letter.to_s.downcase
    raise ArgumentError if letter.nil? || letter.empty? || nonletter(letter)
    return false if (@guesses.include?(letter) || @wrong_guesses.include?(letter))
    if @word.include? letter
      @guesses += letter
      encode_guess_word(letter)
    else
      @wrong_guesses += letter
    end
    true
  end

  def encode_guess_word(letter)
    @word.split('').each_with_index do |c, i|
      if c == letter
        @word_with_guesses[i] = c
      end
    end
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    elsif not @word_with_guesses.include? '-'
      return :win
    else
      return :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  private
  def nonletter(letter)
    (letter =~ /[[:alpha:]]/).nil?
  end
end
