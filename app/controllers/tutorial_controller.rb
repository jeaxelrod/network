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
end
