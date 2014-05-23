Rails.application.routes.draw do

  root 'welcome#index'

  resources :users

  resources :events do
    member do
      post 'register' => 'registrations#create'
      delete 'remove_from_waitlist' => 'registrations#destroy'
    end
  end
  resources :login

end
