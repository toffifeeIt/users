Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users 
      post '/sign_in' => 'users#sign_in'
      post '/sign_out' => 'users#sign_out'
      # resources :sessions, only: [:new, :create, :destroy]
    end
  end
end
