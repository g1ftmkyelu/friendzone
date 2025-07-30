Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # User authentication routes
  get '/signup', to: 'users#new', as: 'signup'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # Top-level route for friends list
  get '/friends', to: 'friendships#index', as: 'friends'
  # Top-level route for friend requests page
  get '/friend_requests', to: 'friendships#requests', as: 'friend_requests'

  # Route for exploring/searching users
  get '/explore', to: 'users#search', as: 'explore_users'

  resources :users, only: [:show, :create, :edit, :update] do
    member do
      # The 'friends' member route is not needed if a top-level 'friends' route exists for the navbar
      # get :friends
      get :friend_requests
    end
  end

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :friendships, only: [:create, :update, :destroy]
  # The collection route for friend requests was moved to a top-level route for clarity and direct access.

  resources :messages, only: [:index, :show, :create]

  resources :communities do
    resources :community_memberships, only: [:create, :update, :destroy]
  end

  resources :blogs

  # Defines the root path route ("/")
  root "home#index"
end