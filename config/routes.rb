Rails.application.routes.draw do
  devise_for :users
  devise_for :admins  

  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'
  root 'dashboard#index'
  resources :dashboard, only: %i[index]
  namespace :admin do   
    resources :dashboard, only: %i[index]
    resources :payment_methods
    resources :payments, only: %i[index]
    resources :orders, only: [:show] do
      post 'approved', on: :member
      post 'reject', on: :member
    end
  end

  namespace :user do
    resources :dashboard, only: %i[index]    
    resources :companies, only: %i[new create]    
    resources :payment_methods, only: %i[show index] do
      resources :user_payment_methods
    end
    resources :products
  end

  namespace :api do
    namespace :v1 do
      resources :customers, only: [:create]
      resources :orders, only: %i[create index]
    end
  end
end
