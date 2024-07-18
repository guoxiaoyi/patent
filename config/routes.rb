Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }
      post 'users/send_verification_code', to: 'api/v1/users/verification_codes#create'
    
      resources :histories
      resources :ideas do
        post 'stream', on: :collection
      end
      # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    
      # Defines the root path route ("/")
      # root "articles#index"
    
      namespace :admin do
        # 管理后台的路由在此添加
        resources :dashboard, only: [:index]
      end
    end
  end
  
  mount ActionCable.server => "/cable" 

end
