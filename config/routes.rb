Rails.application.routes.draw do
  devise_for :admins  

  root 'admin/dashboard#index'
  namespace :admin do 
    resources :dashboard, only: %i[index]
    resources :payment_methods, only: %i[index new create show]
  end
end
