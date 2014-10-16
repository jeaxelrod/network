class Board < ActiveRecord::Base
  validates :game_type, inclusion: { in: %w(local multiplayer computer random tutorial) }
  serialize :black, Array
  serialize :white, Array
end
