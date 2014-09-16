require "rails_helper"

RSpec.describe NetworkFinder, :type => :service do
  describe "finding networks" do 
    before :all do
      chips = {:black => [20, 60, 42, 13, 33, 25, 35, 55, 65, 57]}
      @networks = NetworkFinder.new(:chips => chips)
    end 

    it "should not have any white networks" do
      expect(@networks.white[:complete].empty?).to eql(true)
      expect(@networks.white[:incomplete].empty?).to eql(true)
    end
    it "should have valid networks" do 
      expect(@networks.black[:complete]).to       include([60, 65, 55, 33, 35, 57])
      expect(@networks.black[:incomplete]).to_not include([60, 65, 55, 33, 35, 57])
      expect(@networks.black[:complete]).to       include([20, 25, 35, 13, 33, 55, 57])
      expect(@networks.black[:incomplete]).to_not include([20, 25, 35, 13, 33, 55, 57])
    end
    it "should not have networks with more than one chip in a goal area" do
      expect(@networks.black[:complete]).to_not   include([60, 20, 42, 33, 35, 57])
      expect(@networks.black[:incomplete]).to_not include([60, 20, 42, 33, 35, 57])
      expect(@networks.black[:complete]).to_not   include([20, 42, 60, 65, 55, 57])
      expect(@networks.black[:incomplete]).to_not include([20, 42, 60, 65, 55, 57])
    end
    it "should not pass through the same chip twice" do
      expect(@networks.black[:complete]).to_not   include([20, 25, 35, 55, 35, 57])
      expect(@networks.black[:incomplete]).to_not include([20, 25, 35, 55, 35, 57])
    end
    it "should not have network that doesn't change direction after each chip" do
      expect(@networks.black[:complete]).to_not   include([60, 42, 33, 35, 55, 57])
      expect(@networks.black[:incomplete]).to_not include([60, 42, 33, 35, 55, 57])
    end
  end  
end
