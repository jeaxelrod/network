require "rails_helper"

RSpec.describe "Game simulation", :type => :service do
  it "Random Computer vs Random Computer 100 times" do 
    white_winners = 0 
    range = 100
    range.times do   
      player1 = RandomComputer.new
      player2 = RandomComputer.new
      game = Game.new(player1, player2)
      game.run
      white_winners+=1 if game.winner == :white
    end
    expect(white_winners/range.to_f).to eql(0.5)
  end

  it "ComputerPlayer vs Random Computer 100 times" do
    black_winners = 0
    range = 100
    range.times do
      player1 = RandomComputer.new
      player2 = ComputerPlayer.new
      game = Game.new(player1, player2)
      game.run
      black_winners += 1 if game.winner == :black
    end
    expect(black_winners/range.to_f).to eql(0.5)
  end
end
