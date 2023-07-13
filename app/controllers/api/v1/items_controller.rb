class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { error: "Item not found" }, status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render json: { error: "Record not created: No fields can be blank" }, status: 422
    end
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end