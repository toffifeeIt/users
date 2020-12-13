Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users 
      post 'users/sign_in' => 'users#sign_in'
      # resources :sessions, only: [:new, :create, :destroy]
    end
  end
end
