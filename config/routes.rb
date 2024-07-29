Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # 平台
      devise_for :tenant_managers, controllers: {
        sessions: 'api/v1/tenant_managers/sessions'
      }
      # 租户
      devise_for :tenants, controllers: {
        sessions: 'api/v1/tenants/sessions'
      }

      # 用户
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }

      namespace :users do
        resources :verification_codes, only: [:create]
      end
      # post 'users/', to: 'users/verification_codes#create'
    
      resources :histories
      resources :chats
      resources :ideas
      # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    
      # Defines the root path route ("/")
      # root "articles#index"
    
      namespace :tenants do
        # 管理后台的路由在此添加
        resources :dashboard, only: [:index]
        resources :users
      end

      namespace :tenant_managers do
        resources :tenants
        resources :dashboard, only: [:index]
      end
    end
  end
  
  mount ActionCable.server => "/cable" 

end
