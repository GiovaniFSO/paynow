Rails.application.routes.draw do
  devise_for :users
  devise_for :admins  

  #root 'user/dashboard#index'
  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'
  root 'dashboard#index'
  resources :dashboard, only: %i[index]
  namespace :admin do   
    resources :dashboard, only: %i[index]
    resources :payment_methods
  end

  namespace :user do
    resources :dashboard, only: %i[index]    
  end
end
