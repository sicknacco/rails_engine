require 'rails_helper'

describe "Items API" do
  describe "get api/v1/items" do
    it "gets a list of all items" do
      merchant = create(:merchant)
      items = create_list(:item, 4, merchant_id: merchant.id)

      get '/api/v1/items'
      
      expect(response).to be_successful
      
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(4)
      
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        expect(item[:id].to_i).to be_an(Integer)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end

  describe "get api/v1/items/:id" do
    it "can get one item by it's id" do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      
      get "/api/v1/items/#{item1.id}"
      
      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:id].to_i).to eq(item1.id)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end
  end

  describe "post /items" do
    it "can create a new item" do
      merchant = create(:merchant)
      @item_params = {
        name: 'New Item',
        description: 'New Description',
        unit_price: 10.99,
        merchant_id: merchant.id
      }

      post '/api/v1/items', params: { item: @item_params}

      expect(response).to be_successful

      item = JSON.parse(response.body)

      expect(item[:name]).to eq('New Item')
      expect(item[:description]).to eq('New Description')
      expect(item[:unit_price]).to eq(10.99)
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end
end