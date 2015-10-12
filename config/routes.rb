Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'home#index'

  # Static pages
  get 'mobile' => 'pages#mobiles'
  get '/report' => 'pages#report'
  get '/contact' => 'pages#contact'
  get '/reglas' => 'pages#rules'
  get '/nosotros' => 'pages#about'
  get '/match_info' => 'matches#match_info'
  get '/live_matches' => 'home#live_matches'

  # Seasons
  get '/seasons/0' => 'pages#season0'

  # User list
  get 'users', to: 'users#index'

  resources :match_tokens, only: [:edit, :update]
  resources :matches do
    member do
      get :join
      post :leave
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks', :registrations => 'registrations' }

  get 'user/:username' => 'users#show', constraints: { username: /[^:]+/ }
  get 'users/:username' => 'users#show', constraints: { username: /[^:]+/ }, as: 'user'
  put 'users/:id' => 'users#update', constraints: { username: /[^:]+/ }
end
