class NetworkController < ApplicationController
  def index
  end
  
  def local
    #Play on your local machine
    game = Board.new(game_type: "local")
    game.save
    @game_id = game.id
  end

  def online
    #Play with other players online
    #@game = Board.new(game_type: "multiplayer")
    #@game_id = @game.id
    @pending_player = PendingPlayer.new
  end
  
  def createPlayer 
  end
  
  def multiplayer
  end

  def random 
    #Play against an AI
    game = Board.new(game_type: "random")
    game.save
    @game_id = game.id
  end

  def computer 
    game = Board.new(game_type: "computer")
    game.save
    @game_id = game.id
  end

  def getNetworks 
    @chips = params[:chips]
    @network_finder = NetworkFinder.new(:chips => @chips) 

    @networks =  JSON.generate({:white => @network_finder.white, :black => @network_finder.black}) 
    respond_to do |format|
      format.json do
        render json: @networks
      end
    end
  end

  def update
    begin
      game = Board.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry we lost your game"
      #TODO Redirect isn't working
      render :js => "window.location.pathname='#{root_path.to_json}'"
      return
    end
    chips = {white: game.white, black: game.black}
    network_finder = NetworkFinder.new(:chips => chips)
    @data = {}
    @data[:chips] = {white: game.white, black: game.black}
    @data[:networks] = {white: network_finder.white, black: network_finder.black}
    respond_to do |format|
      format.json do
        render json: @data
      end
    end
  end

  def placeChip
    begin
      game = Board.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry we lost your game"
      #TODO Redirect isn't working
      render :js => "window.location.pathname='#{root_path.to_json}'"
      return
    end
    @data = {}
    @chips = format_chips(params[:chips])
    case game.game_type
    when "local"
      @data[:color] = params[:color] == "white" ? "black" : "white"
    when "computer"
      computer_player = ComputerPlayer.new({:chips => @chips, :search_depth => 3})
      move = computer_player.move(:black)
      @chips[:black] << move.added_chip
      @chips[:black].delete(move.deleted_chip)
      @data[:color] = "white"
    when "random"
      random_computer = RandomComputer.new(:chips => @chips)
      move = random_computer.move(:black)
      @chips[:black] << move.added_chip
      @chips[:black].delete(move.deleted_chip)
      @data[:color] = "white";
    when "multiplayer"
      @data[:color] = params[:color] == "white" ? "black" : "white"
    when "tutorial"
      @data[:color] = params[:color]
    end
    @data[:chips] = {:white => @chips[:white], :black => @chips[:black]}
    network_finder = NetworkFinder.new(:chips => @chips)
    @data[:networks] = {:white => network_finder.white, :black => network_finder.black}
    
    game.white = @chips[:white]
    game.black = @chips[:black]
    if game.save
      respond_to do |format|
        format.json do
          render json: JSON.generate(@data)
        end
      end
    else
      #DO SOMETHING
    end
  end

  private

  def format_chips(chips)
    white_chips = chips[:white] ? chips[:white].map { |a| a.to_i } : []
    black_chips = chips[:black] ? chips[:black].map { |a| a.to_i } : []
    {:white => white_chips, :black => black_chips}
  end
end
