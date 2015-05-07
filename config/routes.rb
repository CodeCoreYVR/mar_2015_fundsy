Rails.application.routes.draw do

  resources :my_campaigns, only: :index

  resources :groups do
    resources :memberships
  end

  get 'welcome/index'

  # urls will be like
  # /api/v1/campaigns
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :campaigns
    end
  end
  
  resources :discussions do
    resources :comments, only: [:create]
  end

  resources :campaigns do
    resources :comments, only: [:create]
    resources :pledges, only: [:create, :destroy]
    resources :publishings, only: [:create]
  end

  resources :pledges, only: [] do
    resources :payments, only: [:new, :create]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    # we do this because we don't need an id to log
    # the user out. The user id is in the session and it
    # should be included in the URL
    delete :destroy, on: :collection
  end

  root "welcome#index"

end
