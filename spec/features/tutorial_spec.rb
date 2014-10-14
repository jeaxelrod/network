require 'rails_helper'

feature "Tutorial on game board" do
  scenario "Introduction to goal areas should be fully playable board", js: true do
    visit tutorial_board_path

    within(".goal_area") { page.all('td.white_goal')[0].click }
    within(".goal_area") { page.all('td.black_goal')[0].click }

    within(".goal_area .board_table") { expect(page.all("div.white.chip").count).to eql(1) }
    within(".goal_area .board_table") { expect(page.all("div.black.chip").count).to eql(1) }
  end
  scenario "intro to white playable area should only play white chips", js: true do
    visit tutorial_board_path

    within(".white_board") { page.all('td.white_goal')[0].click }
    within(".white_board") { page.all('td.white_goal')[1].click }
    within(".white_board") { page.all('td.black_goal')[0].click }

    within(".white_board .board_table") { expect(page.all("div.white.chip").count).to eql(2) }
    within(".white_board .board_table") { expect(page.all("div.black.chip").count).to eql(0) }
  end
  scenario "intro to black playable area should only play black chips", js: true do
    visit tutorial_board_path

    within(".black_board") { page.all('td.black_goal')[0].click }
    within(".black_board") { page.all('td.black_goal')[1].click }
    within(".black_board") { page.all('td.white_goal')[0].click }

    within(".black_board .board_table") { expect(page.all("div.black.chip").count).to eql(2) }
    within(".black_board .board_table") { expect(page.all("div.white.chip").count).to eql(0) }
  end 
end

feature "Tutorial on step move" do
  scenario "should let you perform step moves", js: true do
    visit tutorial_chip_placement_path

    within(".board_table") { page.all("div.white.chip")[0].click }
    within(".board_table") { page.all("td.white_goal")[0].click }

    within(".board_table") { expect(page.all("td.white_goal div.white.chip").count).to eql(1) }
  end
end

feature "Tutorial on complete networks" do
  scenario "should not let you add more chips", js: true do
    visit tutorial_network_path

    within(".board_table") { page.all('td.board_square')[10].click }

    within(".board_table") { expect(page.all("div.white.chip").count).to eql(0) }
    within(".board_table") { expect(page.all("div.black.chip").count).to eql(10) }
  end
  
  scenario "should let you view complete networks", js: true do
    visit tutorial_network_path

    within(".network_highlighter") { page.all("a")[0].click }

    within(".board_table") { expect(page.all("td.winner").count).to eql(6) }
  end
end

    
