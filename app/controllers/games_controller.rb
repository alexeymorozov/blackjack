class GamesController < ApplicationController
  def new
  end

  def create
    if session[:game_id].nil?
      @game = Blackjack::Game.create
      @game.start_round
      session[:game_id] = @game.object_id
      redirect_to game_path
    end
  end

  def show
    @game = Blackjack::Game.find(session[:game_id])
  end
end
