class NetworkFinder
  attr_reader :white, :black, :network
  BLACK_GOAL_AREAS = [10, 20, 30, 40, 50, 60, 17, 27, 37, 47, 57, 67]
  WHITE_GOAL_AREAS = [1, 2, 3, 4, 5, 6, 71, 72, 73, 74, 75, 76]

  def initialize(params)
    @black_chips = []
    @white_chips = []
    @networks_found = false
    if params[:chips]
      chips = params[:chips]
      chips.each do |index, chip|
        coord = (chip["coord"]).to_i
        if chip["color"] == "black"
          @black_chips << coord 
        elsif chip["color"] == "white"
          @white_chips << coord 
        end
      end
    else
      @black_chips = params[:black_chips] if params[:black_chips]
      @white_chips = params[:white_chips] if params[:white_chips]
    end
    @white = find_networks(:white)
    @black = find_networks(:black)
    @network = { :white => @white, :black => @black }
  end
  
  private  

  def find_networks(color)
    networks = { :complete => [], :incomplete => [] }
    initial_networks = beginning_networks(color)
    unless initial_networks.empty?
      initial_networks.each do |network|
        new_networks = find_networks_from(network, color) 
        networks[:complete] += new_networks[:complete]
        networks[:incomplete] += new_networks[:incomplete]
      end
    end
    networks[:complete].sort! { |x, y| y.length <=> x.length }
    networks[:incomplete].sort! { |x, y| y.length <=> x.length }
    networks
  end

  def beginning_networks(color)
    networks = []
    if color == :black
      foreign_chips = @white_chips
      own_chips = @black_chips
      goal_chips = own_chips.select { |a| BLACK_GOAL_AREAS.include?(a) }
    else
      foreign_chips = @black_chips
      own_chips = @white_chips
      goal_chips = own_chips.select { |a| WHITE_GOAL_AREAS.include?(a) }
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
      :top => [-9, 1, 11],
      :right => [9, -10, -9],
      :left => [9, 10, 11] }
    goal = get_goal_area(goal_chip)
    action = goals_with_actions[goal]
    action.each do |action|
      current_coord = goal_chip
      next_chip = nil
      while next_chip == nil
        current_coord += action
        if in_goal_area?(current_coord) || @white_chips.include?(current_coord)
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
    if goal_chip < 10
      goal = :left
    elsif goal_chip > 70
      goal = :right
    elsif goal_chip % 10 == 0
      goal = :top
    elsif goal_chip % 10 == 7
      goal = :bottom
    else
      raise "Chip not within a goal area"
    end   
    goal
  end

  def find_networks_from(network, color)
    networks = { :complete => [], :incomplete => [] } 
    if network.length >= 5
      goal_chips = get_next_chips(network, color, :goal => true)
      goal_chips.each do |chip|
       current_network = network + [chip]
       networks[:complete] += [current_network]
      end
    end
    next_chips = get_next_chips(network, color)
    next_chips.each do |chip|
      current_network = network + [chip]
      networks[:incomplete] += [current_network]
      new_networks = find_networks_from(current_network, color)
      networks[:incomplete] += new_networks[:incomplete]
      networks[:complete] += new_networks[:complete]
    end
    networks 
  end

  def get_next_chips(network, color, options = {})
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
    prev_chip = network[-2]
    chip = network[-1]
    next_chips = []
    if options[:goal]
      filter_area = lambda { |chip| past_goal_area?(chip) }
    else
      filter_area = lambda { |chip| in_goal_area?(chip) }
    end
    if color == :black
      foreign_chips = @white_chips.dup
      own_chips = @black_chips.dup
      if options[:goal]
        own_chips = own_chips.select { |a| BLACK_GOAL_AREAS.include?(a) }
      end
    else
      foreign_chips = @black_chips.dup
      own_chips = @white_chips.dup
      if options[:goal]
        own_chips = own_chips.select { |a| WHITE_GOAL_AREAS.include?(a) }
      end
    end
    directions_with_actions.delete(getDirection(prev_chip, chip))
    directions_with_actions.each do |direction, action|
      current_coord = chip
      next_chip = nil
      while next_chip == nil
        current_coord += action
        if filter_area.call(current_coord) || 
            foreign_chips.include?(current_coord) ||
            network.include?(current_coord)
          break
        end
        if own_chips.include? current_coord
          next_chip = current_coord
          next_chips << next_chip
        end
      end
    end
    next_chips
  end
  
  def past_goal_area?(chip)
    if chip <= 0 || chip >= 77 || chip % 10 > 7 
      return true
    else
      return false
    end
  end

  def in_goal_area?(chip)
    if chip % 10 <= 0 || chip > 70 || chip % 10 >= 7 || chip < 10 
      return true
    else
      return false
    end
  end

  def getDirection(prev_chip, chip)
    x_change = chip/10 - prev_chip/10
    y_change = chip%10 - prev_chip%10
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
    elsif x_change < 0
      direction = "-"
    elsif x_change > 0
      direction = "+"
    end
    if y_change == 0
      direction += "0"
    elsif y_change < 0
      direction += "-"
    elsif y_change > 0
      direction += "+"
    end
    directions[direction]
  end
end
