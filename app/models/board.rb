class Board < ActiveRecord::Base
  validates :game_type, inclusion: { in: %w(local multiplayer computer) }
  serialize :black
  serialize :white
end
