Rails.application.routes.draw do

  get 'welcome/index'

  resources :users, only: [:new, :create]

  root "welcome#index"

end
