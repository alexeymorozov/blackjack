class GamesController < ApplicationController
  rescue_from Blackjack::GameNotFound, with: :game_not_found
  rescue_from Blackjack::InvalidAction, with: :invalid_action
  rescue_from Blackjack::EmptyDeck, with: :empty_deck
  rescue_from Blackjack::GameOver, with: :game_over

  def new
  end

  def create
    game = Blackjack::Game.create
    session[:game_id] = game.object_id
    redirect_to game_path
  end

  def show
    @game = current_game
  end

  def bet
    current_game.bet(params[:amount])
    redirect_to game_path
  end

  def stand
    current_game.stand
    redirect_to game_path
  end

  def hit
    current_game.hit
    redirect_to game_path
  end

  def start_round
    current_game.start_round
    redirect_to game_path
  end

  private

  def game_not_found
    flash[:error] = "The game could not be found, please start a new one."
    redirect_to new_game_path
  end

  def invalid_action
    flash[:error] = "Invalid action, please choose another one."
    redirect_to game_path
  end

  def empty_deck
    flash[:error] = "The deck is empty. Game over! Please start a new one."
    redirect_to game_path
  end

  def game_over
    flash[:error] = "Game over! Please start a new one."
    redirect_to game_path
  end

  def current_game
    Blackjack::Game.find(session[:game_id])
  end
end
