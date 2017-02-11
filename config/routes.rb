Rails.application.routes.draw do

  authenticate :user do
    resources :tournaments, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :tournaments, only: [:index, :show]
  get 'home/index'

  get 'home/show'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
