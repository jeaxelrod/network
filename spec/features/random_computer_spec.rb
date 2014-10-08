require 'rails_helper'
require 'pry'

feature "Random computer player" do
  scenario "Adding a chip", js: true do
    visit computer_path

    all('td.board_square')[10].click

    within(".board_table") { expect(page.all("div.chip").count).to eql(2) } 
  end
  scenario "Step moves", js: true do
    visit computer_path
    place_ten_chips = false
    placed_chips = []
    possible_points = [39, 23, 15, 40, 32, 8, 39, 35, 27, 53, 52, 50, 49, 13, 12, 10, 9]
    until place_ten_chips
      point = possible_points.pop
      unless all('td.board_square')[point].has_css?("div.chip")
        all('td.board_square')[point].click
        placed_chips << point
      end
      place_ten_chips = true if placed_chips.length >= 10
    end
    
    all('td.board_square')[placed_chips[9]].click
    all('td.board_square')[47].click

    expect(page.all("div.chip").count).to eql(20)
    within(".board_table") do 
      within(page.all('td.board_square')[47]) { expect(page).to have_css "div.chip" }
    end 
    within(".board_table") do
      within(page.all('td.board_square')[placed_chips[9]]) { expect(page).to_not have_css "div.chip" }
    end 
  end
end
