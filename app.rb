require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
	if(session[:game] == nil && session[:word] != nil)
		@game = HangpersonGame.new(session[:word])
		@game.guesses = session[:guesses]
		@game.wrong_guesses = session[:wrong_guesses]
	end
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
	buff = params[:word]
	if(params[:word]=='' or !(buff==buff[/[a-zA-Z]+/]))
		params[:word] = nil
	end
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!
	word.downcase!
    @game = HangpersonGame.new(word)
	session[:word] = @game.word
	session[:guesses] = @game.guesses
	session[:wrong_guesses] = @game.wrong_guesses
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
	if(params[:guess] == nil || params[:guess] == "")
		flash[:message] = "Invalid guess."
		redirect '/show'
	end
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###
	if(@game.if_valid?(letter))
		if(!@game.if_guessed?(letter))
			if @game.guess(letter)
				session[:guesses] = session[:guesses] + letter
			else
				session[:wrong_guesses] = session[:wrong_guesses] + letter
			end
		else
			flash[:message] = "You have already used that letter."
		end
	else
		flash[:message] = "Invalid guess."
	end
	redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
	if(@game.check_win_or_lose == :win)
		redirect '/win'
	elsif(@game.check_win_or_lose == :lose)
		redirect '/lose'
	end
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
	if(@game.check_win_or_lose == :lose)
		redirect '/lose'
	elsif(@game.check_win_or_lose == :play)
		redirect '/show'
	end
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
	if(@game.check_win_or_lose == :win)
		redirect '/win'
	elsif(@game.check_win_or_lose == :play)
		redirect '/show'
	end
    erb :lose # You may change/remove this line
  end
  
  def word_with_guesses(word_, guesses_)
	x = ''
	word_.split("").each{ |y|
		if(guesses_.include?(y))
			x = x+y
		else
			x = x+'-'
		end
	}
	x
  end
end
