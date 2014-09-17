require 'rails_helper'
require "pry"

RSpec.describe "pending_players/index.html.erb", :type=> :view, js: true do
  before(:each) do
    @other_player = PendingPlayer.create
    @pending_player = PendingPlayer.create
    @pending_ids = PendingPlayer.where.not(id: @pending_player.id).map { |player| player.id }
  end
  it "should display the other player" do
    render
    binding.pry
    expect(rendered).to have_content("Play")
    expect(rendered).to have_content("Player")
  end
end
