Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'home#index'

  # Static pages
  get '/report' => 'pages#report'
  get '/contact' => 'pages#contact'
  get '/rules' => 'pages#rules'
  get '/nosotros' => 'pages#about'
  get '/match_info' => 'matches#match_info'
  get '/live_matches' => 'home#live_matches'

  get 'users', to: 'users#index'

  resources :match_tokens, only: [:edit, :update]
  resources :matches do
    member do
      get :join
      post :leave
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => "registrations"}

  get "user/:username" => "users#show", :constraints => { username: /[^:]+/ }
  get "users/:username" => "users#show", :constraints => { username: /[^:]+/ }, :as => 'user'
  put "users/:id" => "users#update", :constraints => { username: /[^:]+/ }


end
