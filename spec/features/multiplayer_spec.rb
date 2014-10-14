require 'rails_helper'

feature "Multiplayer Game" do

  before :all do
    @user_1 = Capybara::Session.new(:selenium, Rails.application)
    @user_2 = Capybara::Session.new(:selenium, Rails.application)
    @user_2.visit pending_players_path
    @user_1.visit pending_players_path
    sleep(8.seconds) #Wait for @user_2 to update
  end

  scenario "Find other players", js: true do

    
    expect(@user_1).to have_content("Play")
    expect(@user_1).to have_content("Player")
    expect(@user_2).to have_content("Play")
    expect(@user_2).to have_content("Player")
  end
  
  scenario "Start a game", js: true do
    @user_1.click_link "Play"

    expect(@user_1).to have_css "table.board_table"
    expect(@user_1).to have_css "td.board_square"
    expect(@user_1.all(".board_table td.board_square").count).to eql(64) 

    expect(@user_2).to have_css "table.board_table"
    expect(@user_2).to have_css "td.board_square"
    expect(@user_2.all(".board_table td.board_square").count).to eql(64) 
  
  end

  scenario "Second player should not be able to place a chip", js: true do
    @user_2.find('td.board_square21').click

    @user_2.within(".board_table") { expect(@user_2.all("div.chip").count).to eql(0) }
  end

  scenario "First play adds a chip", js: true do
    @user_1.find('td.board_square1').click
    sleep(3.seconds) #Wait for user_2 board to update
    @user_1.within(".board_table") { expect(@user_1.all("div.chip").count).to eql(1) }
    @user_2.within(".board_table") { expect(@user_2.all("div.chip").count).to eql(1) }
  end
end
