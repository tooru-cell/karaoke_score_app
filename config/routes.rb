Rails.application.routes.draw do
  get "/rankings", to: "rankings#index"
  get "mypage", to: "static_pages#summary", as: :mypage
  root "static_pages#top"

  get "terms", to: "static_pages#terms", as: :terms
  get "privacy", to: "static_pages#privacy", as: :privacy

  resources :karaoke_scores
  resources :songs, only: [ :show ] do
    member do
      get :history
    end
  end

  resources :users, only: %i[new create]

  get "account/edit", to: "users#edit", as: :edit_account
  patch "account", to: "users#update", as: :account

  resources :song_memos, only: [ :index, :create, :destroy ]

  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
