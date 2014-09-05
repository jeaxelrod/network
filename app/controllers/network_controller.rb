class NetworkController < ApplicationController
  include NetworkHelper
  def index
  end
  def placeChip
    @chips = params[:chips]
    @networks = getNetworks(@chips)
    respond_to do |format|
      format.json do
        render json: @chips
      end
    end
  end
end
