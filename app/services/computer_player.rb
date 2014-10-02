class ComputerPlayer
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
    @search_depth = params[:search_depth] || 2 #TODO Tinker with default
    @color = params[:color] || :black
  end

  def move(color)
    choose_move(color, -1, 1)
  end
  
  private
  
  def choose_move(color, alpha, beta, depth = @search_depth)
    my_move = Move.new(color)
    if (depth == 0) || has_winner?
      my_move.score = evaluate_board()
      return my_move
    end 
    legal_moves = all_legal_moves(color)
    my_move = legal_moves.sample
    if color == :white
      other_color = :black
    else
      other_color = :white
    end
    if color == @color
      #Computer's move;
      my_move.score = alpha
    else 
      my_move.score = beta
    end
    legal_moves.each do |move|
      @chips[color] << move.added_chip
      @chips[color].delete(move.deleted_chip) if move.deleted_chip
      reply = choose_move(other_color, alpha, beta, depth - 1)
      @chips[color].delete(move.added_chip)
      @chips[color] << move.deleted_chip if move.deleted_chip
      if color == @color && reply.score > my_move.score  
        my_move = move
        my_move.score = reply.score
        alpha = reply.score
      elsif color == other_color && replay.score < my_move.score
        my_move = move
        my_move.score = reply.score
        beta = reply.score
      end
      if alpha >= beta
       return my_move
      end
    end
    return my_move
  end
  
  def has_winner?
    network_finder = NetworkFinder.new(chips: @chips)
    return :white if network_finder.white[:complete].any?
    return :black if network_finder.black[:complete].any?
    return nil
  end
  def evaluate_board
    puts @chips
    network_finder = NetworkFinder.new(chips: @chips)
    if network_finder.white[:complete].any?
      puts -1
      return -1
    elsif network_finder.black[:complete].any?
      puts 1
      return 1
    else
      num_non_goal_black_pairs = num_non_goal_pairs(:black)
      num_non_goal_white_pairs = num_non_goal_pairs(:white) 
      num_from_goal_black_pairs = num_pairs_from_goal(:black)
      num_from_goal_white_pairs = num_pairs_from_goal(:white)
      black_points = num_from_goal_black_pairs * 2 + num_non_goal_black_pairs
      white_points = num_from_goal_white_pairs * 2 + num_non_goal_white_pairs
      puts white_points
      puts black_points
      score = black_points/20.0 - white_points/20.0
      puts score
      return score
    end
  end

  def num_non_goal_pairs(color)
    directions = [-11, -1, 9, -10, 10, -9, 1, 11]
    num_of_pairs = 0
    if color == :black
      foreign_chips = @chips[:white]
      own_chips = @chips[:black]
    elsif color == :white
      foreign_chips = @chips[:black]
      own_chips = @chips[:white]
    end
    own_chips.each do |chip|
      if non_goal_area?(chip)
        directions.each do |action|
          curr_chip = chip
          next_chip = nil
          curr_chip += action
          while next_chip == nil && non_goal_area?(curr_chip) 
            if own_chips.include?(curr_chip)
              next_chip = curr_chip
              num_of_pairs+=1
            elsif foreign_chips.include?(curr_chip)
              next_chip = curr_chip
            end
            curr_chip += action
          end
        end
      end
    end
    return num_of_pairs/2
  end

  def num_pairs_from_goal(color)
    directions = [-11, -1, 9, -10, 10, -9, 1, 11]
    num_pairs = 0
    if color == :black
      foreign_chips = @chips[:white]
      own_chips = @chips[:black]
      goal_chips = own_chips.select { |n| n % 10 == 0 || n % 10 == 7}
    elsif color == :white
      foreign_chips = @chips[:white]
      own_chips = @chips[:black]
      goal_chips = own_chips.select { |n| n / 10 == 0 || n / 10 == 7}
    end
    goal_chips.each do |chip|
      directions.each do |action|
        curr_chip = chip
        next_chip = nil
        curr_chip += action
        while next_chip == nil && non_goal_area?(curr_chip)
          if own_chips.include?(curr_chip)
            next_chip = curr_chip
            num_pairs += 1
          elsif foreign_chips.include?(curr_chip)
            next_chip = curr_chip
          end
          curr_chip += action
        end
      end
    end
    return num_pairs
  end

  def non_goal_area?(point)
    return point % 10 > 0 && point % 10 < 7 && point / 10 > 0 && point / 10 < 70
  end
  
  def all_legal_moves(color) 
    legal_moves = []
    if @chips[:black].length >= 10
      (0..9).each do |n|
        deleted_point = @chips[color].delete_at(n)
        legal_points = get_legal_points(color)
        legal_points.each do |point|
          legal_moves.push(Move.new(color, point, deleted_point)) unless point == deleted_point
        end
        @chips[color].insert(n, deleted_point)
      end
    else
      legal_points = get_legal_points(color)
      legal_points.each do |point|
        legal_moves.push(Move.new(color, point))
      end
    end
    return legal_moves.shuffle
  end

  def get_legal_points(color)
    connected_points = get_connected_points(color)
    if color == :black
      legal_points = BLACK_MOVES - connected_points - @chips[:black] - @chips[:white]
    elsif color == :white
      legal_points = WHITE_MOVES - connected_points - @chips[:white] - @chips[:white]
    else
      #TODO handle error
    end
    legal_points
  end


  def get_connected_points(color)
    connected_points = []
    test_points = []
    if color == :black
      own_chips = @chips[:black]
      total_moves = BLACK_MOVES
    elsif color == :white
      own_chips = @chips[:black]
      total_moves = WHITE_MOVES
    else
      #TODO handle color error
    end
    own_chips.each do |chip|
      chipx = chip/ 10
      chipy = chip % 10
      for i in -1..1
        for j in -1..1
          point = (chipx + i)*10 + (chipy + j)
          if (BLACK_MOVES.include?(point) && test_points.exclude?(point) && 
              @chips[:white].exclude?(point) && @chips[:black].exclude?(point))
            test_points << point
          end
        end
      end
    end
    test_points.each do |point|
      connected_points << point if connected_point?(color, point)
    end
    return connected_points
  end
  
  def connected_point?(color, point)
    connected_chips = connected_chips(color, point)
    case connected_chips.length
    when 0
      return false
    when 1
      second_connected_chips = connected_chips(color, connected_chips[0])
      return second_connected_chips.length > 0
    else
      return true 
    end
  end

  def connected_chips(color, point)
    if color == :black
      colored_chips = @chips[:black]
    elsif color == :white
      colored_chips = @chips[:white]
    else
      #TODO handle color error
    end
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
