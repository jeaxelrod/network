class NetworkController < ApplicationController
  def index
  end
  def placeChip
    respond_to do |format|
      format.json do
        render json: []
      end
    end
  end
end
