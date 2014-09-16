class PendingPlayersController < ApplicationController
  def new
    @pending_player = PendingPlayer.new
  end

  def create
    @pending_player = PendingPlayer.new(pending_player_params)
    if @pending_player.save
      session[:id] = @pending_player.id
      redirect_to pending_players_path
    end
  end

  def destroy
  end

  def index
    @pending_players = PendingPlayer.where.not(id: session[:id])
  end

  private

  def pending_player_params
    params.require(:pending_player).permit(:username)
  end
end
