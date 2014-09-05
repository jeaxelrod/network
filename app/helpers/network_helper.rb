module NetworkHelper
  TOP_BLACK_GOAL_AREAS = [10, 20, 30, 40, 50, 60]
  BOTTOM_BLACK_GOAL_AREAS = [17, 27, 37, 47, 57, 67]
  LEFT_WHITE_GOAL_AREAS = [1, 2, 3, 4, 5, 6]
  RIGHT_WHITE_GOAL_AREAS = [71, 72, 73, 74, 75, 76]

  def getNetworks(chips)
    black_chips = []
    white_chips = []
    black_networks = []
    white_networks = []
    chips.each do |index, chip|
      coord = (chip["x_coord"] + chip["y_coord"]).to_i
      if chip["color"] == "black"
        black_chips << coord 
      elsif chip["color"] == "white"
        white_chips << coord 
      end
    end
    black_chips.select { |a| TOP_BLACK_GOAL_AREAS.include? a }.each do |goal_chip|
      current_networks = []
      goal_coord = goal_chip
      next_chip = nil
      for i in 0..2
        current_coord = goal_coord
        case i         
        when 0
          #Move down-left
          while next_chip == nil
            current_coord = current_coord - 9
            if (current_coord < 10 || white_chips.include?(current_coord))
              #Needs to break into next for loop iteration
              break
            end
            if black_chips.include? current_coord 
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 1
          #Move down
          while next_chip == nil
            current_coord = current_coord + 1
            if (current_coord % 10) >= 7 || white_chips.include?(current_coord)
              break
            end
            if black_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 2
          #Move down-right
          while next_chip == nil
            current_coord = current_coord + 11
            if current_coord > 70 || white_chips.include?(current_coord)
              break
            end
            if black_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        end #case
      end #for loop
    end #top_black_goal_areas
    black_chips.select { |a| BOTTOM_BLACK_GOAL_AREAS.include? a }.each do |goal_chip|
      current_networks = []
      goal_coord = goal_chip.to_i
      current_coord = goal_coord
      for i in 0..2
        case i         
        when 0
          #Move up-left
          while next_chip == nil
            current_coord = current_coord - 11 
            if current_coord < 10 || white_chips.include?(current_coord)
              #Needs to break into next for loop iteration
              break
            end
            if black_chips.include? current_coord 
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 1
          #Move up  
          while next_chip == nil
            current_coord = current_coord - 1
            if (current_coord % 10) <= 0 || white_chips.include?(current_coord)
              break
            end
            if black_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 2
          #Move up-right
          while next_chip == nil
            current_coord = current_coord + 9  
            if current_coord > 70 || white_chips.include?(current_coord)
              break
            end
            if black_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        end #case
      end #for loop
    end #top_black_goal_areas
    white_chips.select { |a| LEFT_WHITE_GOAL_AREAS.include? a }.each do |goal_chip|
      current_networks = []
      goal_coord = goal_chip.to_i
      current_coord = goal_coord
      for i in 0..2
        case i         
        when 0
          #Move up-right 
          while next_chip == nil
            current_coord = current_coord + 9
            if (current_coord % 10) <= 0 || black_chips.include?(current_coord)
              #Needs to break into next for loop iteration
              break
            end
            if white_chips.include? current_coord 
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 1
          #Move right 
          while next_chip == nil
            current_coord = current_coord + 10
            if current_coord > 70 || black_chips.include?(current_coord)
              break
            end
            if white_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 2
          #Move down-right
          while next_chip == nil
            current_coord = current_coord + 11
            if (current_coord % 10) >= 7 || black_chips.include?(current_coord)
              break
            end
            if white_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        end #case
      end #for loop
    end #top_black_goal_areas
    white_chips.select { |a| RIGHT_WHITE_GOAL_AREAS.include? a }.each do |goal_chip|
      current_networks = []
      goal_coord = goal_chip.to_i
      current_coord = goal_coord
      for i in 0..2
        case i         
        when 0
          #Move up-left
          while next_chip == nil
            current_coord = current_coord - 11
            if (current_coord % 10) <= 0 || black_chips.include?(current_coord)
              #Needs to break into next for loop iteration
              break
            end
            if white_chips.include? current_coord 
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 1
          #Move left 
          while next_chip == nil
            current_coord = current_coord - 10
            if current_coord < 10 || black_chips.include?(current_coord)
              break
            end
            if white_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        when 2
          #Move down-left
          while next_chip == nil
            current_coord = current_coord - 9
            if (current_coord % 10) >= 7 || black_chips.include?(current_coord)
              break
            end
            if white_chips.include? current_coord
              next_chip = current_coord
              current_networks += find_networks_from([goal_chip, next_chip], current_coord)
            end
          end
        end #case
      end #for loop
    end #top_black_goal_areas
  end
  def find_networks_from(current_network, chips)
    return [1]
  end
end
