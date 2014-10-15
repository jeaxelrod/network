class TutorialController < ApplicationController

  def teams
  end

  def board
    board = Board.new(game_type: "local")
    board.save
    @board_id = board.id
    white_board = Board.new(game_type: "tutorial")
    white_board.save
    @white_board_id = white_board.id
    black_board = Board.new(game_type: "tutorial")
    black_board.save
    @back_board_id = black_board.id
  end

  def chip_placement
    white_chips = [11, 31, 51, 13, 33, 53, 15, 35, 55, 16]
    step_move_board = Board.new(game_type: "tutorial", white: white_chips, black: [])
    step_move_board.save
    @chips = {white: step_move_board.white, black: step_move_board.black}
    @step_move_board_id = step_move_board.id
  end

  def network
    goal_area_board = Board.new(game_type: "local")
    goal_area_board.save
    @goal_area_board_id = goal_area_board.id
    black_chips = [20, 60, 42, 13, 33, 35, 55, 65, 57, 37]
    network_board = Board.new(game_type: "tutorial", white: [], black: black_chips)
    network_board.save
    @network_chips = {white: network_board.white, black: network_board.black}
    network_finder = NetworkFinder.new(chips: @network_chips)
    @complete_networks = {black: network_finder.black[:complete], white: network_finder.white[:complete]}
    @networks = {black: network_finder.black, white: network_finder.white}
    @network_board_id = network_board.id

  end
end
