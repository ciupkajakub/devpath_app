Rails.application.routes.draw do
  devise_for :users, path: 'user', controllers: { sessions: 'users/sessions',
                                                  passwords: 'users/passwords',
                                                  confirmations: 'users/confirmations' },
             skip: [:registrations]
  devise_for :admins, path: 'admin', controllers: { sessions: 'admins/sessions',
                                                    passwords: 'admins/passwords',
                                                    confirmations: 'admins/confirmations' },
             skip: [:registrations]

  post 'purchase_products' => 'purchase_products#create', as: :create_purchase_products
  patch 'cart' => 'cart#update', as: :update_purchase_product
  delete 'cart' => 'cart#destroy', as: :destroy_purchase_product
  put 'cart' => 'cart#buy', as: :buy_purchase_products #how to solve two update actions

  resources :cart, only: [:index]

  root 'home#index'

  devise_scope :user do
    get 'user/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'user' => 'users/registrations#update', :as => 'user_registration'
    get '/user/main' => 'users/users#index', as: :user_main
    resources :user_purchases
  end

  devise_scope :admin do
    get 'admin/edit' => 'admins/registrations#edit', :as => 'edit_admin_registration'
    put 'admin' => 'admins/registrations#update', :as => 'admin_registration'
    get '/admin/main' => 'admins/admins#index', as: :admin_main
    get '/admin/users' => 'admins/admins#index', as: :users#wtf
    post 'admin/users' => 'admins/users#create', as: :create_user
    get '/admin/users/new' => 'admins/users#new', as: :new_users
  end

  scope 'admin' do
    resources :categories, controller: 'admins/categories'
    # post 'products' => 'admins/products#upload_product_csv', as: :upload_product_csv
    resources :products, controller: 'admins/products' do
      member do
        patch 'archive', as: :archive
      end
      collection do
        post 'upload_product_csv'
      end
    end
    resources :purchases, controller: 'admins/purchases'
    resources :statistics, controller: 'admins/statistics'
  end

  scope 'user' do
    resources :user_purchases, controller: 'users/user_purchases'
  end
  resources :products, only: [:index, :show]
end
