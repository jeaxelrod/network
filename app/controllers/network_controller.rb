class NetworkController < ApplicationController
  include NetworkHelper
  def index
  end
  def placeChip
    @chips = params[:chips]
    @network_finder = NetworkFinder.new(:chips => @chips) 

    @networks =  JSON.generate({:white => @network_finder.white, :black => @network_finder.black}) 
    respond_to do |format|
      format.json do
        render json: @networks
      end
    end
  end
end
