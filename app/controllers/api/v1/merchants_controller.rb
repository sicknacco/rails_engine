class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find_by(id: params[:id])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { error: "Merchant not found" }, status: 404
    end
  end

  # def find
  #   name = params[:name]
  #   if name.present?
  #     merchant = Merchant.name_search(name)
  #     if merchant
  #       render json: MerchantSerializer.new(merchant), status: :ok
  #     else
  #       render json: { error: "Merchant not found" }, status: 404
  #     end
  #   else
  #     render json: { error: "Name is required" }, status: 400
  #   end
  # end
end