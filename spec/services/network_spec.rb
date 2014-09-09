require "rails_helper"

RSpec.describe Networks, :type => :service do
  describe "finding networks" do 
    before :all do
      chips = {"0" => {"color" => "black", "coord" =>"20"},
               "1" => {"color" => "black", "coord" =>"60"},
               "2" => {"color" => "black", "coord" =>"42"},
               "3" => {"color" => "black", "coord" =>"13"},
               "4" => {"color" => "black", "coord" =>"33"},
               "5" => {"color" => "black", "coord" =>"25"},
               "6" => {"color" => "black", "coord" =>"35"},
               "7" => {"color" => "black", "coord" =>"55"},
               "8" => {"color" => "black", "coord" =>"65"},
               "9" => {"color" => "black", "coord" =>"57"}}
      @networks = Networks.new(:chips => chips)
      @networks.networks
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
