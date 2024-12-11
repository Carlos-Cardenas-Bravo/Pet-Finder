Rails.application.routes.draw do
  resources :pets
  root "welcome#index"

  get "users/profile"
  devise_for :users
  get "profile", to: "users#profile", as: :user_profile

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
