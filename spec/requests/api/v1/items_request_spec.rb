require 'rails_helper'

describe "Items API" do
  describe "GET api/v1/items" do
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

  describe "GET api/v1/items/:id" do
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

  describe "POST /app/v1/items" do
    it "can create a new item" do
      merchant = create(:merchant)
      item_params = {
        name: 'New Item',
        description: 'New Description',
        unit_price: 11.99,
        merchant_id: merchant.id
      }

      post '/api/v1/items', params: { item: item_params}

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data][:attributes][:name]).to eq('New Item')
      expect(item[:data][:attributes][:description]).to eq('New Description')
      expect(item[:data][:attributes][:unit_price]).to eq(11.99)
      expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  describe "PUT /api/v1/items/:id" do
    it "can update an existing item" do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)

      update_params = {
        name: "Update Item",
        description: "Updated Description",
        unit_price: 20.99,
        merchant_id: merchant.id
      }

      put "/api/v1/items/#{item1.id}", params: { item: update_params }

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data][:attributes][:name]).to eq('Update Item')
      expect(item[:data][:attributes][:description]).to eq('Updated Description')
      expect(item[:data][:attributes][:unit_price]).to eq(20.99)
      expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  describe "DELETE /api/v1/items/:id" do
    it "can delete an existing item" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"
      
      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /api/v1/items/:id/merchant" do
    it "returns the merchant data for a given item id" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merch_data = JSON.parse(response.body, symbolize_names: true)

      expect(merch_data[:data][:id].to_i).to eq(merchant.id)
      expect(merch_data[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  describe "Sad Path Tests" do
    describe "GET /api/v1/items" do
      it "returns an empty array when there are no items" do
        get "/api/v1/items"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data]).to be_empty
        ## expect it to be an array
      end
    end

    describe "GET /api/v1/items/:id" do
      it "returns error when an item is not found" do
        get "/api/v1/items/9999"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
        error = JSON.parse(response.body, symbolize_names: true)
        
        expect{Item.find(9999)}.to raise_error(ActiveRecord::RecordNotFound)
        expect(error[:error]).to eq("Item not found")
      end
    end

    describe "POST /api/v1/items" do
      describe "when invalid parameters are provided" do
        it "returns an error message and status 404" do
          merchant = create(:merchant)
          invalid_item_params = {
            name: nil,
            description: 'New Description',
            unit_price: 11.99,
            merchant_id: merchant.id
          }
    
          post '/api/v1/items', params: { item: invalid_item_params }
    
          expect(response).not_to be_successful
          expect(response).to have_http_status(404)
    
          error = JSON.parse(response.body, symbolize_names: true)
    
          expect(error[:error]).to eq("Record not created: No fields can be blank")
        end
      end
    end

    describe "PUT /api/v1/items/:id" do
      describe "when updating with invalid parameters" do
        it "returns an error message and status 404" do
          merchant = create(:merchant)
          item = create(:item, merchant_id: merchant.id)
    
          invalid_update_params = {
            name: nil,
            description: "Updated Description",
            unit_price: 20.99,
            merchant_id: merchant.id
          }
    
          put "/api/v1/items/#{item.id}", params: { item: invalid_update_params }
    
          expect(response).not_to be_successful
          expect(response).to have_http_status(404)
    
          error = JSON.parse(response.body, symbolize_names: true)
    
          expect(error[:error]).to eq("Record not updated: No fields can be blank")
        end
      end
    end

    describe "GET /api/v1/items/:id/merchant" do
      it "returns error when an item is not found" do
        get "/api/v1/items/9999/merchant"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
        error = JSON.parse(response.body, symbolize_names: true)
        
        expect{Item.find(9999)}.to raise_error(ActiveRecord::RecordNotFound)
        expect(error[:error]).to eq("Item not found")
      end
    end
  end
end