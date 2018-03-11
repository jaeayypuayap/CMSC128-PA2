class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
	@wrong_guesses = ''
	@guesses = ''
  end
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def guess (letter)
	if(letter.nil?)
		raise ArgumentError 
		return false
	end
	letter.downcase!
	if(letter == '' || !if_valid?(letter))
		raise ArgumentError 
		return false
	end
	
	if if_guessed? letter
		return false
	end
	if @word.include?(letter)
		@guesses = @guesses + letter
		return true
	else
		@wrong_guesses = @wrong_guesses + letter
		return false
	end
  end
  
  def if_guessed?(letter)
	ret = false
	@guesses.split("").each{|x|
		if(letter == x)
			ret = true
			break
		end
	}
	if(!ret)
		@wrong_guesses.split("").each{ |x|
			if(letter == x)
				ret = true
				break
			end
		}
	end
	ret
  end
  
  def if_valid?(letter)
	"abcdefghijklmnopqrstuvwxyz".include?(letter)
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def word_with_guesses
	x = ''
	@word.split("").each{ |y|
		if(@guesses.include?(y))
			x = x+y
		else
			x = x+'-'
		end
	}
	x
  end
  
  def check_win_or_lose
	if(word_with_guesses == @word)
		return :win
	elsif(@wrong_guesses.length >= 7)
		return :lose
	else
		return :play
	end
  end
end
