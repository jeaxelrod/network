module NetworkHelper
  BLACK_GOAL_AREAS = [10, 20, 30, 40, 50, 60, 17, 27, 37, 47, 57, 67]
  WHITE_GOAL_AREAS = [1, 2, 3, 4, 5, 6, 71, 72, 73, 74, 75, 76]
  @black_chips = []
  @white_chips = []

  def get_networks(chips)
    chips.each do |index, chip|
      coord = (chip["x_coord"] + chip["y_coord"]).to_i
      if chip["color"] == "black"
        @black_chips << coord 
      elsif chip["color"] == "white"
        @white_chips << coord 
      end
    end
    white_networks = array_of_networks(:white)
    black_networks = array_of_networks(:black)
    return {:white_networks => white_networks, :black_networks => black_networks}
  end

  def array_of_networks(color)
    networks = [] 
    initial_networks = beginning_networks(color)
    unless initial_networks.empty?
      initial_networks.each do |network|
        networks += find_networks_from(network, color)
      end
    end
  end

  def beginning_networks(color)
    networks = []
    goals_with_actions= {
      :bottom => [-11, -1, 9],
      :top => [-9, 1, 11] 
      :right => [9, -10, -9],
      :left => [9, 10, 11] }
    }
    if color == :black
      foreign_chips = @white_chips
      own_chips = @black_chips
      goal_chips = own_chips.select { |a| BLACK_GOAL_AREAS.include? a }
    else
      foreign_chips = @black_chips
      own_chips = @white_chips
      goal_chips = own_chips.select { |a| WHITE_GOAL_AREAS.include? a }
    end

    goal_chips.each do |chip|
      chips = get_chips_connected_to_goal_chip(chip) 
      chips.each do |second_chip|
        networks << [chip, second_chip]
      end
    end
    networks
  end

  def get_chips_connected_to_goal_chip(goal_chip)
    chips = [] 
    goals_with_actions= {
      :bottom => [-11, -1, 9],
      :top => [-9, 1, 11] 
      :right => [9, -10, -9],
      :left => [9, 10, 11] }
    }
    goal = get_goal_area(goal_chip)
    action = goals_with_actions[goal]
    action.each do |action|
      current_coord = goal_chip
      next_chip = nil
      while next_chip == nil
        current_coord += action
        if (in_goal_area?(chip)) || @white_chips.include?(current_coord))
          break
        end
        if @black_chips.include? current_coord
          next_chip = current_coord
          chips += [next_chip]
        end
      end
    end
    chips
  end


  def get_goal_area(goal_chip)
    if chip < 10
      goal = :left
    elsif chip > 70
      goal = :right
    elsif chip % 10 == 0
      goal = :top
    elsif chip % 10 == 7
      goal = :bottom
    else
      raise "Chip not within a goal area"
    end   
    goal
  end

  def find_black_networks_from(network)
    black_networks = []
    prev_chip = network[-2]
    current_chip = network[-1]
    next_chips = get_next_chips(goal_chip, current_chip, network)
    next_chips.each do |chip|
      current_network = network + [chip]
      black_networks += find_black_networks_from(current_network)
    end
    black_networks
  end

  def get_next_chips(prev_chip, chip, network)
    directions_with_actions = {
      :up_left    => -11,
      :up         => -1,
      :up_right   => 9,
      :left       => -10,
      :right      => 10,
      :down_left  => -9,
      :down       => 1,
      :down_right => 11
    }
    next_chips = []
    directions.delete(getDirection(prev_chip, chip))
    directions.each do |direction|
      action = directions_with_actions[direction] 
      current_coord = chip
      while next_chip == nil
        current_coord += action
        if (in_goal_area?(current_coord) || 
            @white_chips.include? current_coord ||
            network.include? current_coord)
          break
        end
        if @black_chips.include? current_coord
          next_chip = current_coord
          next_chips << next_chip
        end
      end
    end
  end

  def in_goal_area?(chip)
    if (chip % 10 <= 0 || chip > 70 || chip >= 7 || chip < 10) 
      return true
    else
      return false
    end
  end

  def getDirection(prev_chip, chip)
    x_change = prev_chip/10 - chip/10
    y_change = prev_chip%10 - chip%10
    directions = { 
      "--" => :up_left,
      "0-" => :up,
      "+-" => :up_right,
      "-0" => :left,
      "+0" => :right,
      "-+" => :down_left,
      "0+" => :down,
      "++" => :down_right
    }
    if x_change == 0
      direction = "0"
    else if x_change < 0
      direction = "-"
    else if x_change > 0
      direction = "+"
    end
    if y_change == 0
      direction += "0"
    else if y_change < 0
      direction += "-"
    else if y_change > 0
      direction += "+"
    end
    directions[direction]
  end
  
end
