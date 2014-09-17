require 'rails_helper'
require 'pry'

feature "Multiplayer Game" do

  scenario "Finding other players", js: true do
    visit pending_players_path
    visit pending_players_path

    expect(page).to have_content("Play")
    expect(page).to have_content("Player")
  end
end
