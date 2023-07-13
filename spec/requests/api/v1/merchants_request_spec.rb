require 'rails_helper'

describe "Merchants API" do
  describe "GET api/v1/merchants" do
    it "gets a list of all merchants" do
      create_list(:merchant, 3)
      
      get '/api/v1/merchants'
      
      expect(response).to be_successful
      
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)
      
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant[:id].to_i).to be_an(Integer)
        
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end
  end
  
  describe "GET api/v1/merchants/:id" do
    it "can get one merchant by it's id" do
      merchant1 = create(:merchant)
      
      get "/api/v1/merchants/#{merchant1.id}"
      
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id].to_i).to eq(merchant1.id)
      
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_an(String)
    end
  end
  
  describe "GET api/v1/merchants/:id/items" do
    it "can get all of a specific merchant's items" do
      merchant = create(:merchant)
      items = create_list(:item, 4, merchant_id: merchant.id)
      
      get "/api/v1/merchants/#{merchant.id}/items"
      
      expect(response).to be_successful
      
      merchant_items = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchant_items[:data].count).to eq(4)

      merchant_items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        expect(item[:id].to_i).to be_an(Integer)
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_an(Float)
      end
    end
  end

  describe "Sad Path Tests" do
    describe "GET /api/v1/merchants" do
      it "returns an empty array when there are no merchants" do
        get "/api/v1/merchants"

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data]).to be_empty
      end
    end

    describe "GET /api/v1/merchants/:id" do
      it "returns error when a merchant is not found" do
        get "/api/v1/merchants/9999"

        expect(response).to have_http_status(404)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error[:error]).to eq("Merchant not found")
      end
    end
  end
end