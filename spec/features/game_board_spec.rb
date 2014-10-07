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
    all('td.board_square')[10].click

    expect(page).to have_css "td div.chip"
  end
  scenario "User adds a chip to an existing chip", js: true do
    visit local_path
    all('td.board_square')[10].click
    all('td.board_square')[10].click

    within(".board_table") { expect(page).to have_css "td div.white.chip" }
    within(".board_table") { expect(page.all("div.chip").count).to eql(1) }
  end
  scenario "Adding chip to two chips in a connected group", js: true do
    visit local_path
    all('td.board_square')[10].click
    all('td.board_square')[1].click
    all('td.board_square')[11].click
    all('td.board_square')[2].click
    all('td.board_square')[12].click

    within(".board_table") { expect(page.all("div.chip").count).to eql(4) }
  end
  scenario "Adding chip to two chips in a connected group", js: true do
    visit local_path
    all('td.board_square')[10].click
    all('td.board_square')[3].click
    all('td.board_square')[12].click
    all('td.board_square')[2].click
    all('td.board_square')[11].click

    within(".board_table") { expect(page.all("div.white.chip").count).to eql(2) }
  end
  
  scenario "Performing a step move", js: true do
    visit local_path
    all('td.board_square')[9].click
    all('td.board_square')[1].click
    all('td.board_square')[10].click
    all('td.board_square')[2].click
    all('td.board_square')[12].click
    all('td.board_square')[4].click
    all('td.board_square')[13].click
    all('td.board_square')[5].click
    all('td.board_square')[25].click
    all('td.board_square')[17].click
    all('td.board_square')[26].click
    all('td.board_square')[18].click
    all('td.board_square')[28].click
    all('td.board_square')[20].click
    all('td.board_square')[29].click
    all('td.board_square')[21].click
    all('td.board_square')[41].click
    all('td.board_square')[33].click
    all('td.board_square')[42].click
    all('td.board_square')[34].click

    all('td.board_square')[42].click
    all('td.board_square')[43].click

    expect(page.all("div.chip").count).to eql(20)
    within(page.all("td.board_square")[41]) { expect(page).to have_css "div.chip" }
    within(page.all("td.board_square")[42]) { expect(page).to_not have_css "div.chip" }
    within(page.all("td.board_square")[43]) { expect(page).to have_css "div.chip" }
  end
  scenario "Performing a step move on the wrong color", js: true do
    visit local_path
    all('td.board_square')[9].click
    all('td.board_square')[1].click
    all('td.board_square')[10].click
    all('td.board_square')[2].click
    all('td.board_square')[12].click
    all('td.board_square')[4].click
    all('td.board_square')[13].click
    all('td.board_square')[5].click
    all('td.board_square')[25].click
    all('td.board_square')[17].click
    all('td.board_square')[26].click
    all('td.board_square')[18].click
    all('td.board_square')[28].click
    all('td.board_square')[20].click
    all('td.board_square')[29].click
    all('td.board_square')[21].click
    all('td.board_square')[41].click
    all('td.board_square')[33].click
    all('td.board_square')[42].click
    all('td.board_square')[34].click

    all('td.board_square')[34].click

    expect(page.all("div.chip").count).to eql(20)
    expect(page).to_not have_css ".step_move"
  end
  scenario "Cancelling a step move and then performing one", js: true do
    visit local_path
    all('td.board_square')[9].click
    all('td.board_square')[1].click
    all('td.board_square')[10].click
    all('td.board_square')[2].click
    all('td.board_square')[12].click
    all('td.board_square')[4].click
    all('td.board_square')[13].click
    all('td.board_square')[5].click
    all('td.board_square')[25].click
    all('td.board_square')[17].click
    all('td.board_square')[26].click
    all('td.board_square')[18].click
    all('td.board_square')[28].click
    all('td.board_square')[20].click
    all('td.board_square')[29].click
    all('td.board_square')[21].click
    all('td.board_square')[41].click
    all('td.board_square')[33].click
    all('td.board_square')[42].click
    all('td.board_square')[34].click

    all('td.board_square')[41].click
    all('td.board_square')[41].click
    all('td.board_square')[42].click
    all('td.board_square')[43].click
    expect(page.all("div.chip").count).to eql(20)
    within(page.all("td.board_square")[41]) { expect(page).to have_css "div.chip" }
    within(page.all("td.board_square")[42]) { expect(page).to_not have_css "div.chip" }
    within(page.all("td.board_square")[43]) { expect(page).to have_css "div.chip" }
  end
end
