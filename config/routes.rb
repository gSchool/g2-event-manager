Rails.application.routes.draw do

  root 'welcome#index'

  resources :users
  post '/users/:id/reset', to: 'users#reset_password', as: 'user_reset'
  get '/users/:id/reset', to: 'users#reset_password_form', as: 'reset_form'
  resources :events do
    resources :registrations, only: [:create, :destroy]
  end
  resources :login

end
