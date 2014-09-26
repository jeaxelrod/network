class ComputerPlayer
  attr_accessor :chips, :black, :white
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

  def initialize(params)
    @chips = params[:chips] || {black: [], white: []}
    @black = @chips[:black] || []
    @white = @chips[:white] || []
    @search_depth = params[:search_depth] || 5 #TODO Tinker with default
    @color = params[:color] || :black
  end

  def move(color)
    if @black.length >= 10
      choose_step_move(color)
    else
      choose_move(color, -1, 1)
    end
  end
  
  private
  
  def choose_move(color, alpha, beta, depth = @search_depth)
    my_move = Move.new(color)
    if (depth == 0) || has_winner?(chips)
      my_move.score = evaluate_board()
      return my_move
    end 
    if color == @color
      #Computer's move;
      my_move.score = alpha
    else 
      my_move.score = beta
    end
    legal_moves = all_legal_moves(color)
    my_move.added_chip = legal_moves.sample

    legal_moves.each do |move|
      @chips[color] << move
      reply = choose_move(other_color, alpha, beta, depth - 1)
      @chips[color].delete(move)
      if color == @color && reply.score > my_move.score  
        my_move = m
        my_move.score = reply.score
        alpha = reply.score
      elsif color == other_color && replay.score > my_move.score
        my_move.move = m
        my_move.score = reply.score
        beta = reply.score
      end
      if alpha >= beta
       return my_move
      end
    end
    return my_move
  end

  def evaluate_board
  end

  def all_legal_moves(color)
    connected_points = get_connected_points(color)
    if color == :black
      legal_moves = BLACK_MOVES - connected_points - @black - @white
    elsif color == :white
      legal_moves = WHITE_MOVES - connected_points - @white - @white
    else
      #TODO handle error
    end
    return legal_moves
  end

  def get_connected_points(color)
    connected_points = []
    test_points = []
    if color == :black
      own_chips = @black
      total_moves = BLACK_MOVES
    elsif color == :white
      own_chips = @black
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
              @white.exclude?(point) && @black.exclude?(point))
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
      colored_chips = @black
    elsif color == :white
      colored_chips = @white
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
        
  
      

=begin
  This is the pseudo code for alpha beta pruning

  public Best chooseMove(boolean side,
    int alpha, int beta) {
    Best myBest = new Best(); // My best move
    Best reply; // Opponent’s best reply

    if ("this" Grid is full or has a win) {
      return a Best with the Grid’s score, no move;
    }
    if (side == COMPUTER) {
      myBest.score = alpha;
    } else {
      myBest.score = beta;
    }
    myBest.move = any legal move;
    for (each legal move m) {
      perform move m; // Modifies "this" Grid
      reply = chooseMove(! side, alpha, beta);
      undo move m; // Restores "this" Grid
      if (side == COMPUTER && reply.score > myBest.score) {
        myBest.move = m;
        myBest.score = reply.score;
        alpha = reply.score;
      } else if (side == HUMAN && reply.score < myBest.score) {
        myBest.move = m;
        myBest.score = reply.score;
        beta = reply.score;
      }
      if (alpha >= beta) { return myBest; }
    }
    return myBest;
  }
=end
