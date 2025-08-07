# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#logout', as: :logout

    root to: 'bulletins#index'
    get 'profile', to: 'bulletins#profile', as: :profile
    resources :bulletins do
      member do
        patch :send_to_moderation
        patch :archive
      end
    end

    namespace :admin do
      root to: 'bulletins#dashboard'
      resources :bulletins do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end
      resources :categories
    end
  end
end
