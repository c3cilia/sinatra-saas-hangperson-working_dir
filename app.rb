require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'


class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
    response.set_cookie("game_status", "started")
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
    word = params[:word] || HangpersonGame.get_random_word
    @game = HangpersonGame.new(word)  
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    if letter != nil
      if (@game.wrong_guesses.include? letter) || (@game.guesses.include? letter)
        flash[:message] = "You have already used that letter"
      end 
    	@game.guess(letter)
    end 
    
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
  	game_status = @game.check_win_or_lose
  	if game_status == :win
      response.set_cookie 'game_status', 'ended'
  		redirect '/win'
  	elsif game_status == :lose
      response.set_cookie 'game_status', 'ended'
  		redirect '/lose'
  	end
    erb :show 
  end
  
  get '/win' do
    if (@game.check_win_or_lose == :win) && (request.cookies['game_status'] == 'ended')
      erb :win
    else
      if @game.word.length <= 0
        redirect '/'
      end 
      flash[:game_status_message] = "Sorry!! don't navigate manually"
      redirect '/show'
    end
  end
  
  get '/lose' do
    if (@game.check_win_or_lose == :lose) && (request.cookies['game_status'] == 'ended')
      erb :lose
    else
      if @game.word.length <= 0
        redirect '/'
      end 
      flash[:game_status_message] = "Sorry!! don't navigate manually"
      redirect '/show'
    end 
  end
  
end
