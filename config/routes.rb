Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items"
      end
      resources :items, except: [:new, :edit] do
        resources :merchant, only: [:index], controller: "items/merchants"
      end
    end
  end
end
