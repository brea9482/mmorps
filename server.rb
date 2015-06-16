require "sinatra"
require 'pry'

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def game(move)
  human_choice = move
  computer_choice = rand(3)

  @player_score = 0
  @computer_score = 0

  # 0 = rock
  # 1 = paper
  # 2 = scissors

  if computer_choice == 0 && human_choice == 'r'
    return 'Player chose rock. Computer chose rock. Tie, choose again.'
  end
  if computer_choice == 0 && human_choice == 'p'
    @player_score += 1
    return 'Player chose paper. Computer chose rock. Paper beats rock,
    Player wins the round.'
  end
  if computer_choice == 0 && human_choice == 's'
    @computer_score += 1
    return 'Player chose scissors. Computer chose rock.
    Rock beats scissors, Computer wins the round.'
  end

  if computer_choice == 1 && human_choice == 'r'
    @computer_score += 1

    return 'Player chose rock. Computer chose paper.
    Paper beats rock, Computer wins the round.'
  end
  if computer_choice == 1 && human_choice == 'p'
    return 'Player chose paper. Computer chose paper. Tie, choose again.'
  end
  if computer_choice == 1 && human_choice == 's'
    @player_score += 1
    return 'Player chose scissors. Computer chose paper.
    Scissors beats paper, Player wins the round.'
  end

  if computer_choice == 2 && human_choice == 'r'
    @player_score += 1
    return 'Player chose rock. Computer chose scissors.
    Rock beats scissors, Player wins the round.'
  end
  if computer_choice == 2 && human_choice == 'p'
    @computer_score += 1
    return 'Player chose paper. Computer chose scissors.
    Scissors beats paper, Computer wins the round.'
  end
  if computer_choice == 2 && human_choice == 's'
    return 'Player chose scissors. Computer chose scissors. Tie, choose again.'
  end
end

def computer_count
  return @computer_score
end

def human_count
  return @player_score
end

def winner(human,computer)
  if human > computer
    return "Player wins the game!"
  else
    return "Computer wins the game!"
  end
end

get '/game' do
  session[:gameplay]
  session[:human]
  session[:computer]

  if session[:winner] != nil
    redirect '/winner'
  end

  erb :index
end

get '/winner' do
  session[:gameplay]
  session[:human]
  session[:computer]
  session[:winner]

  erb :show
end

post '/game' do
  session[:gameplay] = game(params[:choice].downcase[0])

  session[:human] ||= 0
  session[:computer] ||= 0

  session[:human] += human_count
  session[:computer] += computer_count

  if session[:computer] == 2 || session[:human] == 2
    session[:winner] = winner(session[:human],session[:computer])
  end

  redirect '/game'
end

post '/winner' do
  replay = params
  if replay != nil
    session.clear
    redirect '/game'
  end
end
