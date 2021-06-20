Rails.application.routes.draw do
  devise_for :users
  devise_for :admins  

  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'
  root 'dashboard#index'
  resources :dashboard, only: %i[index]
  namespace :admin do   
    resources :dashboard, only: %i[index]
    resources :payment_methods
  end

  namespace :user do
    resources :dashboard, only: %i[index]    
    resources :companies, only: %i[new create]    
    resources :payment_methods, only: %i[show index] do
      resources :user_payment_methods, only: %i[show new create edit update]
    end
    resources :products, only: %i[index new create show update edit]
  end

  namespace :api do
    namespace :v1 do
      resources :customers, only: [:create]
      resources :orders, only: [:create]
    end
  end
end
