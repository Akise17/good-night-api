# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :follows, only: [] do
        member do
          post :follow
          delete :unfollow
        end
      end
      resources :trackings, only: %i[index show destroy] do
        collection do
          get :by_followers
          post :clock_in
        end
        member do
          put :clock_out
        end
      end
      resources :users, only: %i[index show create update destroy]
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
