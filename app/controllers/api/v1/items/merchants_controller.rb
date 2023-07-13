class Api::V1::Items::MerchantsController < ApplicationController
  def index
    item = Item.find_by(id: params[:item_id])
    if item.nil?
      render json: { error: "Item not found" }, status: 404
    else
      render json: MerchantSerializer.new(item.merchant)
    end
  end
end