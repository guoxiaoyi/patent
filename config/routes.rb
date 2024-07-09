Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  post 'users/send_verification_code', to: 'users/verification_codes#create'

  resources :histories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :admin do
    # 管理后台的路由在此添加
    resources :dashboard, only: [:index]
  end

end
