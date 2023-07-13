class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    if merchant.nil?
      render json: { error: "Merchant not found" }, status: 404
    else
      items = merchant.items
      render json: ItemSerializer.new(items)
    end
  end
end