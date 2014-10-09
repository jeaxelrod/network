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
end
