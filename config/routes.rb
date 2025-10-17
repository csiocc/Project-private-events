Rails.application.routes.draw do
  root "main_pages#index"

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :news_feeds
  resources :main_pages
  resources :comments
  resources :events do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  resources :invites, only: [:index, :show] do
    member do
      post :accept
      post :decline
    end
  end

  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
    member do
      post 'like', to: 'post_likes#create', as: :like
      post 'unlike', to: 'post_likes#destroy', as: :unlike
    end
  end

  get "users/:id/dating_profile", to: "users#dating_profile", as: "dating_profile"
  get 'users/dating_profile_edit', to: 'users#dating_profile_edit', as: :dating_profile_edit
  get "users/search", to: "users#search"
  resources :users do
    patch :update_photo_order, on: :member
    delete :remove_photo, on: :member
    post :attach_photo
    post 'follow', on: :member
    post 'unfollow', on: :member
    get :owned_posts, on: :member
    get :dating_profile, on: :member
      collection do
        get :dating_profiles
      end
    collection do
      get :swiper
    end
    member do
      post :like
      post :dislike
    end
  end
  
  #daily logger
  resources :daily_logs do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
      get :unread_count
    end
  end
  namespace :api do
  resources :daily_logs, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
