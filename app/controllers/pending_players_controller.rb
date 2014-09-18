class PendingPlayersController < ApplicationController
  def new
  end

  def create
  end

  def destroy
  end

  def update
    @pending_player = PendingPlayer.find(params[:id])
    @pending_player.touch
    if @pending_player.game_requested
      #Return data signifying game is requested
      @game = Board.find(@pending_player.game_id)
      @other_player = PendingPlayer.where(game_id: @game.id).where.not(id: @pending_player.id).first
      @data = JSON.generate({other_id: @other_player.id, game_id: @game.id})
    else
      #Return nada
    end
    respond_to do |format|
      format.json do
        render json: @data 
      end
    end
  end

  def active
    #QUESTION what if session[:id] is nil
    id = session[:id] 
    PendingPlayer.where.not(updated_at: (Time.now - 30)..Time.now).each do |player|
      player.delete
    end
    @pending_ids = PendingPlayer.where.not(id: id).map { |player| player.id }
    @data = JSON.generate({:players => @pending_ids})
    respond_to do |format|
      format.json do 
        render json: @data
      end
    end
  end

  def request_game 
    other_player = PendingPlayer.find(params[:other_id]) 
    this_player = PendingPlayer.find(params[:this_id])
    game = Board.new(game_type: "multiplayer")
    if game.save
      @game_id = game.id
      other_player.update({:game_requested => true, :game_id => @game_id})
      this_player.update({:game_requested => true, :game_id => @game_id})
    end
    respond_to do |format|
      format.json do
        render json: @game_id
      end
    end
  end

  def index
    session[:id] = nil
    @pending_player = PendingPlayer.create
    session[:id] = @pending_player.id
    PendingPlayer.where.not(updated_at: (Time.now - 30)..Time.now).each do |player|
      player.delete
    end
    @pending_players = PendingPlayer.where.not(id: @pending_player.id)
    @pending_ids = @pending_players.map { |player| player.id }
  end

end
