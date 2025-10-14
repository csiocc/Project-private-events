Rails.application.routes.draw do
  devise_for :users
  resources :news_feeds
  resources :main_pages
  resources :invites
  resources :comments
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  get 'users/dating_profile_edit', to: 'users#dating_profile_edit', as: :dating_profile_edit
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
  resources :events

  root "main_pages#index"

  
  get "up" => "rails/health#show", as: :rails_health_check
  get "/privacy", to: "main_pages#privacy_policy", as: :privacy
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
