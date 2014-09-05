class NetworkController < ApplicationController
  def index
  end
  def placeChip
    @chips = params[:chips]
    @networks = NetworkHelper.getNetworks(@chips)
    respond_to do |format|
      format.json do
        render json: @chips
      end
    end
  end
end
