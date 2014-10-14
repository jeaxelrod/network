require 'rails_helper'

feature "Board structure" do 
  scenario "User visits empty board", js: true do
    visit local_path

    expect(page).to have_css "table"
    expect(page).to have_css "tr"
    expect(page).to have_css "td.board_square"
    expect(page.all("tr td.board_square").count).to eql(64) 
  end
  scenario "User adds a chip to the board", js: true do
    visit local_path
    find('td.board_square11').click

    expect(page).to have_css "td div.chip"
  end
  scenario "User adds a chip to an existing chip", js: true do
    visit local_path
    find('td.board_square11').click
    find('td.board_square11').click

    within(".board_table") { expect(page).to have_css "td div.white.chip" }
    within(".board_table") { expect(page.all("div.chip").count).to eql(1) }
  end
  scenario "Adding chip to two chips in a connected group", js: true do
    visit local_path
    find('td.board_square11').click
    find('td.board_square10').click
    find('td.board_square21').click
    find('td.board_square20').click
    find('td.board_square31').click

    within(".board_table") { expect(page.all("div.chip").count).to eql(4) }
  end
  scenario "Adding chip to two chips in a connected group", js: true do
    visit local_path
    find('td.board_square11').click
    find('td.board_square30').click
    find('td.board_square31').click
    find('td.board_square20').click
    find('td.board_square21').click

    within(".board_table") { expect(page.all("div.white.chip").count).to eql(2) }
  end
  
  scenario "Performing a step move", js: true do
    visit local_path

    find('td.board_square11').click
    find('td.board_square10').click
    find('td.board_square21').click
    find('td.board_square20').click
    find('td.board_square41').click
    find('td.board_square40').click
    find('td.board_square51').click
    find('td.board_square50').click
    find('td.board_square13').click
    find('td.board_square12').click
    find('td.board_square23').click
    find('td.board_square22').click
    find('td.board_square43').click
    find('td.board_square42').click
    find('td.board_square53').click
    find('td.board_square52').click
    find('td.board_square15').click
    find('td.board_square14').click
    find('td.board_square25').click
    find('td.board_square24').click

    find('td.board_square25').click
    find('td.board_square35').click

    expect(page.all("div.chip").count).to eql(20)
    within(page.find("td.board_square15")) { expect(page).to have_css "div.chip" }
    within(page.find("td.board_square25")) { expect(page).to_not have_css "div.chip" }
    within(page.find("td.board_square35")) { expect(page).to have_css "div.chip" }
  end
  scenario "Performing a step move on the wrong color", js: true do
    visit local_path

    find('td.board_square11').click
    find('td.board_square10').click
    find('td.board_square21').click
    find('td.board_square20').click
    find('td.board_square41').click
    find('td.board_square40').click
    find('td.board_square51').click
    find('td.board_square50').click
    find('td.board_square13').click
    find('td.board_square12').click
    find('td.board_square23').click
    find('td.board_square22').click
    find('td.board_square43').click
    find('td.board_square42').click
    find('td.board_square53').click
    find('td.board_square52').click
    find('td.board_square15').click
    find('td.board_square14').click
    find('td.board_square25').click
    find('td.board_square24').click

    find('td.board_square24').click

    expect(page.all("div.chip").count).to eql(20)
    expect(page).to_not have_css ".step_move"
  end
  scenario "Cancelling a step move and then performing one", js: true do
    visit local_path

    find('td.board_square11').click
    find('td.board_square10').click
    find('td.board_square21').click
    find('td.board_square20').click
    find('td.board_square41').click
    find('td.board_square40').click
    find('td.board_square51').click
    find('td.board_square50').click
    find('td.board_square13').click
    find('td.board_square12').click
    find('td.board_square23').click
    find('td.board_square22').click
    find('td.board_square43').click
    find('td.board_square42').click
    find('td.board_square53').click
    find('td.board_square52').click
    find('td.board_square15').click
    find('td.board_square14').click
    find('td.board_square25').click
    find('td.board_square24').click

    find('td.board_square15').click
    find('td.board_square15').click
    find('td.board_square25').click
    find('td.board_square35').click

    expect(page.all("div.chip").count).to eql(20)
    within(page.find("td.board_square15")) { expect(page).to have_css "div.chip" }
    within(page.find("td.board_square25")) { expect(page).to_not have_css "div.chip" }
    within(page.find("td.board_square35")) { expect(page).to have_css "div.chip" }
  end
end
