class RandomComputer
  attr_accessor :chips
  BLACK_MOVES = [10, 20, 30, 40, 50, 60, 
                 11, 21, 31, 41, 51, 61, 
                 12, 22, 32, 42, 52, 62,
                 13, 23, 33, 43, 53, 63,
                 14, 24, 34, 44, 54, 64,
                 15, 25, 35, 45, 55, 65,
                 16, 26, 36, 46, 56, 66,
                 17, 27, 37, 47, 57, 67]
  WHITE_MOVES = [ 1,  2,  3,  4,  5,  6,
                 11, 12, 13, 14, 15, 16, 
                 21, 22, 23, 24, 25, 26,
                 31, 32, 33, 34, 35, 36,
                 41, 42, 43, 44, 45, 46,
                 51, 52, 53, 54, 55, 56,
                 61, 62, 63, 64, 65, 66,
                 71, 72, 73, 74, 75, 76]

  def initialize(params = {})
    @chips = params[:chips] || {black: [], white: []}
  end

  def move(color)
    if @chips[:black].length >= 10
      choose_step_move(color)
    else 
      choose_move(color)
    end
  end

  private

  def choose_move(color)
    move = Move.new(color)
    until move.added_chip
      point = random_point(color)
      if valid_move?(@chips, point, color)
        move.added_chip = point
      end
    end
    move
  end

  def choose_step_move(color)
    move = Move.new(color)
    until move.added_chip
      moving_point = pending_step_point(color) 
      point = random_point(color)
      new_chips = @chips.deep_dup
      new_chips[color].delete(moving_point)
      if valid_move?(new_chips, point, :black) && point != moving_point
        move.added_chip = point
        move.deleted_chip = moving_point
        new_chips[color] << point
      end
    end
    move
  end


  def random_point(color)
    if color == :black
      point = BLACK_MOVES.sample
    elsif color == :white
      point = WHITE_MOVES.sample
    else
      #TODO handle error
    end
    point
  end

  def pending_step_point(color)
    @chips[color].sample
  end

  def valid_move?(chips, point, color)
    chips[:black].exclude?(point) && chips[:white].exclude?(point) && legal_connected_group?(chips[color], point)
  end

  def legal_connected_group?(colored_chips, point)
    connected_chips = connected_chips(colored_chips, point)
    case connected_chips.length
    when 0
      return true
    when 1
      second_connected_chips = connected_chips(colored_chips, connected_chips[0])
      return second_connected_chips.length == 0 
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
end
ComputerPlayer.new({chips: {black: [20, 60, 42, 13, 33, 25, 35, 55, 65, 75], white: []}})
