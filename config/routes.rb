Rails.application.routes.draw do

  root 'welcome#index'

  resources :users
  get '/users/calendar/:token', to: 'users#calendar', as: :user_calendar

  resources :events do
    resources :registrations, only: [:create, :destroy]
  end
  resources :login
  resource :reset_passwords
  get '/reset_password/:token', to: 'reset_passwords#edit', as: :edit_password
  patch '/reset_password/:token', to: 'reset_passwords#update', as: :update_password

  get '/confirmation/:token', to: 'confirmation#new', as: :new_confirmation
  patch '/confirmation/:token', to: 'confirmation#create', as: :confirmation
end
