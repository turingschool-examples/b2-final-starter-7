Rails.application.routes.draw do
  get "/", to: "application#welcome"

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
    resources :coupons
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end
  get "/merchants/:id/coupons", to: "coupons#index"
  get "/merchants/:id/coupons/new", to: "coupons#new"
  post "/merchants/:id/coupons/new", to: "coupons#create"
  get "/merchants/:id/coupons/:id", to: "coupons#show"
  patch "/merchants/:id/coupons/:id", to: "coupons#update"
  post "/merchants/:id/coupons/:id", to: "coupons#update"

end
