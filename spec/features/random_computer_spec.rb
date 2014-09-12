require 'rails_helper'
require 'pry'

feature "Random computer player" do
  scenario "Adding a chip", js: true do
    visit computer_path

    all('td.board_square')[10].click

    expect(page.all("div.chip").count).to eql(2)
  end
  scenario "Step moves", js: true do
    visit computer_path
    place_three_chips = false
    placed_chips = []
    possible_points = [36, 35, 27, 28, 12, 11]
    until place_three_chips
      point = possible_points.pop
      unless all('td.board_square')[point].has_css?("div.chip")
        all('td.board_square')[point].click
        placed_chips << point
      end
      place_three_chips = true if placed_chips.length >= 3
    end
    all('td.board_square')[8].click
    all('td.board_square')[16].click
    all('td.board_square')[32].click
    all('td.board_square')[40].click
    all('td.board_square')[15].click
    all('td.board_square')[23].click
    all('td.board_square')[39].click

    all('td.board_square')[39].click
    all('td.board_square')[47].click

    expect(page.all("div.chip").count).to eql(20)
    within(page.all('td.board_square')[39]) { expect(page).to    have_css "div.chip" }
    within(page.all('td.board_square')[47]) { expect(page).to_not have_css "div.chip" }
  end
end
