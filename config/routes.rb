Rails.application.routes.draw do

  get 'welcome/index'

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create, :destroy]

  root "welcome#index"

end
