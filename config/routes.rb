Rails.application.routes.draw do
  require 'sidekiq/web'

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
        resources :customers, only: [:index, :create]
        resources :projects, only: [:index, :create, :update, :destroy]
        resources :recharge_types, only: [:index]
        resources :resource_pack_types, only: [:index]
        resources :payments, only: [:create] do
          post :notify, on: :collection
        end
        resources :features, only: [:show]
        resources :conversations, only: [:index, :create, :show] do
          member do
            get :generate_document
          end
        end
        resources :transactions, only: [:index]
        get 'info', to: 'users#info'

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
        resource :user
        resources :tenants
        resources :recharge_types, only: [:index, :create, :destroy]
        resources :resource_pack_types, only: [:index, :create, :destroy]
        resources :transactions, only: [:index]
        resources :dashboard, only: [:index]
        resources :features, only: [:index, :update] do 
          resources :sub_features, only: [:update]
        end
      end
    end
  end
  
  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => '/admin/sidekiq'

end
