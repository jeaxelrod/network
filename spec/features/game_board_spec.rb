require 'rails_helper'

feature "Board structure" do 
  scenario "User visits empty board", js: true do
    visit root_path

    expect(page).to have_css "table"
    expect(page).to have_css "tr"
    expect(page).to have_css "td.board_square"
    expect { page.all("tr td.board_square").count.to eql(64) }
  end
  scenario "User adds a chip to the board", js: true do
    visit root_path
    all('td.board_square')[1].click

    expect(page).to have_css "td div.chip"
  end
  scenario "User adds a chip to an existing chip", js: true do
    visit root_path
    all('td.board_square')[1].click
    page.choose "color", :unchecked => true
    all('td.board_square')[1].click

    expect(page).to have_css "td div.black.chip"
  end
end
