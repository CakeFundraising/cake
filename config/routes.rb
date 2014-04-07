Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations}
  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end

  resource :fundraiser_profile, only: [:show, :edit, :update]
  resources :organizations

  namespace :locations do
    get :subregion_options
  end

  scope :settings do
    get :public_profile, controller: :settings
    get :account, to: redirect('users/edit')
    resource :email_settings, only: [:edit, :update]
  end

  resources :users, only: :index
end
