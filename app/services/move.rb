class Move
  attr_accessor :score, :color, :added_chip, :deleted_chip

  def initialize(color, added_chip=nil, deleted_chip=nil)
    @color = color
    @added_chip = added_chip
    @deleted_chip = deleted_chip
  end
end
