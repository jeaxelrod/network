class NetworkController < ApplicationController
  include NetworkHelper
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
  end

  def computer
    #Play against an AI
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
    if game.game_type == "local"
      network_finder = NetworkFinder.new(:chips => @chips)
      @data[:networks] = JSON.generate({:white => network_finder.white, :black => network_finder.black})
      @data[:color] = params[:color] == "white" ? "black" : "white"
      @game_id = game.id
      @data[:chips] = JSON.generate(@chips)
    elsif game.game_type == "computer"
      @chips = random_computer_move(@chips)
      @data[:chips] = JSON.generate({:white => @chips[:white], :black => @chips[:black]})
      network_finder = NetworkFinder.new(:chips => @chips)
      @data[:networks] = JSON.generate({:white => network_finder.white, :black => network_finder.black})
      @data[:color] = "white";
    elsif game.game_type == "multiplayer"
    end
    
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

  def random_computer_move(chips)
    total_black_moves = [10, 20, 30, 40, 50, 60, 
                         11, 21, 31, 41, 51, 61, 
                         12, 22, 32, 42, 52, 62,
                         13, 23, 33, 43, 53, 63,
                         14, 24, 34, 44, 54, 64,
                         15, 25, 35, 45, 55, 65,
                         16, 26, 36, 46, 56, 66,
                         17, 27, 37, 47, 57, 67]
    move_found = false

    if chips[:black].length >= 10
      #random_step_move
      until move_found
        moving_chip = chips[:black].sample
        point = total_black_moves.sample
        new_chips = chips.deep_dup
        new_chips[:black].delete(moving_chip)
        if valid_move(new_chips, point, :black)
          move_found = true
          new_chips[:black] << point
          chips = new_chips
        end
      end
    else 
      until move_found
        point = total_black_moves.sample
        if valid_move(chips, point, :black)
          move_found = true
          chips[:black] << point
        end
      end
    end
    return chips
  end

  def valid_move(chips, point, color)
    chips[:white].exclude?(point) && chips[:black].exclude?(point) && legal_connected_group?(chips[color], point)
  end

  def legal_connected_group?(colored_chips, point)
    connected_chips = connected_chips(colored_chips, point)
    case connected_chips.length
    when 0
      return true
    when 1
      second_connected_chips = connected_chips(colored_chips, connected_chips[0])
      return second_connected_chips.length > 0 
    else
      return false
    end
  end

  def connected_chips(colored_chips, point)
    connected_chips = []
    colored_chips.each do |chip|
      chipx = chip / 10
      chipy = chip % 10
      pointx = point / 10
      pointy = point % 10
      if chipx != pointx || chipy != pointy
        if ((pointx - 1)..(pointx + 1)).include?(chipx) &&
           ((pointy - 1)..(pointy + 1)).include?(chipy)
          connected_chips.push(chip)
        end
      end
    end
    return connected_chips 
  end

  def format_chips(chips)
    white_chips = chips[:white] ? chips[:white].map { |a| a.to_i } : []
    black_chips = chips[:black] ? chips[:black].map { |a| a.to_i } : []
    {:white => white_chips, :black => black_chips}
  end
end
