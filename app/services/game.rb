class Game
  attr :chips, :black, :white, :winner

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @chips = {white: [], black: []}
    @white = @chips[:white]
    @black = @chips[:black]
    @winner = nil
  end

  def run
    until @winner
      move = @player1.move(:white)
      @chips[:white] << move.added_chip
      @chips[:white].delete(move.deleted_chip)
      @player1.chips = @chips
      @player2.chips = @chips
      return if has_winner?()
      move = @player2.move(:black)
      @chips[:black] <<  move.added_chip
      @chips[:black].delete(move.deleted_chip)
      @player1.chips = @chips
      @player2.chips = @chips
      return if has_winner?()
    end
  end

  def has_winner?
    network_finder = NetworkFinder.new({chips: @chips})
    if network_finder.white[:complete].any?
      @winner = :white
      return true
    elsif network_finder.black[:complete].any?
      @winner = :black
      return true
    else
      return false
    end
  end
end
