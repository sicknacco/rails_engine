require 'rails_helper'

describe "Merchants API" do
  describe "get api/v1/merchants" do
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

  describe "get api/v1/merchants/:id" do
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
end