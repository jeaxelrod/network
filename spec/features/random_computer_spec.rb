require 'rails_helper'
require 'pry'

feature "Random computer player" do
  scenario "Adding a chip", js: true do
    visit computer_path

    find('td.board_square21').click

    within(".board_table") { expect(page.all("div.chip").count).to eql(2) } 
  end
  scenario "Step moves", js: true do
    visit computer_path
    place_ten_chips = false
    placed_chips = []
    possible_points = [5, 73, 71, 3, 63, 53, 34, 33, 46, 46, 26, 16, 51, 41, 21, 11]
    until place_ten_chips
      point = possible_points.pop
      unless find("td.board_square#{point}").has_css?("div.chip")
        find("td.board_square#{point}").click
        placed_chips << point
      end
      place_ten_chips = true if placed_chips.length >= 10
    end
    
    find("td.board_square#{placed_chips[9]}").click
    find('td.board_square75').click

    expect(page.all("div.chip").count).to eql(20)
    within(".board_table") do 
      within(page.find('td.board_square75')) { expect(page).to have_css "div.chip" }
    end 
    within(".board_table") do
      within(page.find("td.board_square#{placed_chips[9]}")) { expect(page).to_not have_css "div.chip" }
    end 
  end
end
