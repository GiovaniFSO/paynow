Rails.application.routes.draw do
  devise_for :admins  

  root 'admin/dashboard#index'
  namespace :admin do 
    resources :dashboard
  end
end
