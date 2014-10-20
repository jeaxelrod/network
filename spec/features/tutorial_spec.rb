require 'rails_helper'

feature "Tutorial on game board" do
  scenario "Introduction to goal areas should be fully playable board", js: true do
    visit tutorial_board_path

    within(".goal_area") { page.find('td.board_square1').click }
    within(".goal_area") { page.find('td.board_square10').click }

    within(".goal_area .board_table") { expect(page.all("div.white.chip").count).to eql(1) }
    within(".goal_area .board_table") { expect(page.all("div.black.chip").count).to eql(1) }
  end
  scenario "intro to white playable area should only play white chips", js: true do
    visit tutorial_board_path

    within(".white_board") { page.find('td.board_square1').click }
    within(".white_board") { page.find('td.board_square2').click }
    within(".white_board") { page.find('td.board_square10').click }

    within(".white_board .board_table") { expect(page.all("div.white.chip").count).to eql(2) }
    within(".white_board .board_table") { expect(page.all("div.black.chip").count).to eql(0) }
  end
  scenario "intro to white playable area should record a complete network", js: true do
    visit tutorial_board_path

    within(".white_board") { page.find('td.board_square1').click }
    within(".white_board") { page.find('td.board_square21').click }
    within(".white_board") { page.find('td.board_square23').click }
    within(".white_board") { page.find('td.board_square41').click }
    within(".white_board") { page.find('td.board_square43').click }
    within(".white_board") { page.find('td.board_square71').click }
    
    within(".white_board") { expect(page).to have_css("td.winner") }
  end
  scenario "intro to white playable area should play a step move", js: true do
    visit tutorial_board_path

    within(".white_board") { page.find('td.board_square11').click }
    within(".white_board") { page.find('td.board_square31').click }
    within(".white_board") { page.find('td.board_square51').click }
    within(".white_board") { page.find('td.board_square13').click }
    within(".white_board") { page.find('td.board_square33').click }
    within(".white_board") { page.find('td.board_square53').click }
    within(".white_board") { page.find('td.board_square15').click }
    within(".white_board") { page.find('td.board_square35').click }
    within(".white_board") { page.find('td.board_square55').click }
    within(".white_board") { page.find('td.board_square16').click }

    within(".white_board") { page.find("td.board_square11 div.white.chip").click }
    within(".white_board") { page.find("td.board_square1").click }

    within(".white_board") { expect(page).to have_css("td.board_square1 div.white") }
    within(".white_board") { expect(page.all("div.white.chip").count).to eql(10) }
  end
  scenario "intro to black playable area should only play black chips", js: true do
    visit tutorial_board_path

    within(".black_board") { page.find('td.board_square10').click }
    within(".black_board") { page.find('td.board_square20').click }
    within(".black_board") { page.find('td.board_square1').click }

    within(".black_board .board_table") { expect(page.all("div.black.chip").count).to eql(2) }
    within(".black_board .board_table") { expect(page.all("div.white.chip").count).to eql(0) }
  end 
  scenario "intro to black playable area should record a complete network", js: true do
    visit tutorial_board_path

    within(".black_board") { page.find('td.board_square10').click }
    within(".black_board") { page.find('td.board_square12').click }
    within(".black_board") { page.find('td.board_square32').click }
    within(".black_board") { page.find('td.board_square14').click }
    within(".black_board") { page.find('td.board_square34').click }
    within(".black_board") { page.find('td.board_square17').click }

    within(".black_board") { expect(page).to have_css("td.winner") }
  end
  scenario "intro to black playable area should play a step move", js: true do
    visit tutorial_board_path

    within(".black_board") { page.find('td.board_square11').click }
    within(".black_board") { page.find('td.board_square31').click }
    within(".black_board") { page.find('td.board_square51').click }
    within(".black_board") { page.find('td.board_square13').click }
    within(".black_board") { page.find('td.board_square33').click }
    within(".black_board") { page.find('td.board_square53').click }
    within(".black_board") { page.find('td.board_square15').click }
    within(".black_board") { page.find('td.board_square35').click }
    within(".black_board") { page.find('td.board_square55').click }
    within(".black_board") { page.find('td.board_square16').click }

    within(".black_board") { page.find("td.board_square11").click }
    within(".black_board") { page.find("td.board_square10").click }

    within(".black_board") { expect(page).to have_css("td.board_square10 div.black.chip") }
    within(".black_board") { expect(page.all("div.black.chip").count).to eql(10) }
  end
end

feature "Tutorial on step move" do
  scenario "should let you perform step moves", js: true do
    visit tutorial_chip_placement_path

    within(".board_table") { page.all("div.white.chip")[0].click }
    within(".board_table") { page.find("td.board_square1").click }

    within(".board_table") { expect(page.all("td.white_goal div.white.chip").count).to eql(1) }
    within(".board_table") { expect(page.all("div.white.chip").count).to eql(10) }
  end

  scenario "should let you perform step moves twice", js: true do
    visit tutorial_chip_placement_path

    within(".board_table") { page.all("div.white.chip")[0].click }
    within(".board_table") { page.find("td.board_square1").click }
    within(".board_table") { page.all("div.white.chip")[5].click }
    within(".board_table") { page.find("td.board_square71").click }

    within(".board_table") { expect(page.all("td.white_goal div.white.chip").count).to eql(2) }
    within(".board_table") { expect(page.all("div.white.chip").count).to eql(10) }
  end

  scenario "should indicate a complete network", js: true do
    visit tutorial_chip_placement_path

    within(".board_table") { page.all("div.white.chip")[0].click }
    within(".board_table") { page.find("td.board_square1").click }
    within(".board_table") { page.all("div.white.chip")[5].click }
    within(".board_table") { page.find("td.board_square71").click }

    within(".board_table") { expect(page).to have_css("td.winner") }
  end
end

feature "Tutorial on complete networks" do
  scenario "should not let you add more chips", js: true do
    visit tutorial_network_path

    within(".board_table") { page.find('td.board_square21').click }

    within(".board_table") { expect(page.all("div.white.chip").count).to eql(0) }
    within(".board_table") { expect(page.all("div.black.chip").count).to eql(10) }
  end
  
  scenario "should let you view complete networks", js: true do
    visit tutorial_network_path

    within(".network_highlighter") { page.all("a")[0].click }

    within(".board_table") { expect(page.all("td.winner").count).to eql(6) }
  end
end

    
