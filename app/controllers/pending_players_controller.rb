class PendingPlayersController < ApplicationController
  def new
  end

  def create
  end

  def destroy
  end

  def index
    if session[:id]
      @pending_player = PendingPlayer.find(session[:id])
    else
      @pending_player = PendingPlayer.create
      session[:id] = @pending_player.id
    end
    @pending_players = PendingPlayer.where.not(id: @pending_player.id)
    @pending_ids = @pending_players.map { |player| player.id }
  end

end
