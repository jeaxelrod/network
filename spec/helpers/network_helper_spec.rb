require 'rails_helper'
require 'pry'

# Specs in this file have access to a helper object that includes
# the NetworkHelper. For example:
#
# describe NetworkHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe NetworkHelper, :type => :helper do
  include NetworkHelper
  describe "finding first the first chip in a  network" do 
    let(:chips_no_link) { {"0" => {"color" => "black", "x_coord" =>"1", "y_coord"=>"0"}}}
    let(:chips_with_link) { {"0" => {"color" => "black", "x_coord" =>"1", "y_coord"=>"0"},
                             "1" => {"color" => "black", "x_coord" =>"1", "y_coord"=>"4"}} }
    let(:chips_with_white_block) { {"0" => {"color" => "black", "x_coord" =>"1", "y_coord"=>"0"},
                                    "1" => {"color" => "white", "x_coord" =>"2", "y_coord"=>"1"},
                                    "2" => {"color" => "black", "x_coord" =>"3", "y_coord"=>"2"}} }
    it "should not search for more chips" do
      expect(NetworkHelper).to_not receive(:find_networks_from)
      NetworkHelper.getNetworks(chips_no_link)
    end
    it "should search for more chips" do
      expect(NetworkHelper).to receive(:find_networks_from) { [1] }
      NetworkHelper.getNetworks(chips_with_link)
    end
    it "should not search for more chips with a white chip blocking" do
      expect(NetworkHelper).to_not receive(:find_networks_form)
      NetworkHelper.getNetworks(chips_with_white_block)
    end
  end  
end
