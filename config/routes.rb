Rails.application.routes.draw do

  get 'welcome/index'

  resources :campaigns do
    resources :pledges, only: [:create, :destroy]
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
