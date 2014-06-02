Rails.application.routes.draw do

  root 'welcome#index'

  resources :users
  resources :events do
    resources :registrations, only: [:create, :destroy]
  end
  resources :login
  resource :reset_passwords
  get '/reset_password/:token', to: 'reset_passwords#edit', as: :edit_password
  patch '/reset_password/:token', to: 'reset_passwords#update', as: :update_password

end
