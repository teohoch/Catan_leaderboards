Rails.application.routes.draw do
  resources :tournaments
  get 'home/index'

  get 'home/show'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
