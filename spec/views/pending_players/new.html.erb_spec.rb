require 'rails_helper'

RSpec.describe "pending_players/new.html.erb", :type => :view do
  it "displays username creation" do
    @pending_player = PendingPlayer.new
    render
    expect(rendered).to have_content("Username")
  end
end
