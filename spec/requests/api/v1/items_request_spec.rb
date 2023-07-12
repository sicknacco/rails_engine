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
end