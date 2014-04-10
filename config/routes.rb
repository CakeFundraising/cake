Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: 
  {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations, confirmations: :confirmations}

  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end

  resources :campaigns do
    member do
      scope :edit do
        get :sponsors_and_donations
        get :share
      end
      patch :make_visible
      get :badge
    end
  end

  resources :fundraisers, except: :destroy

  namespace :locations do
    get :subregion_options
  end

  scope :settings do
    get :public_profile, controller: :settings

    get :complete_account, to: redirect('fundraisers/new')

    get :account, to: redirect('users/edit')
    resource :email_settings, only: [:edit, :update]
  end

  resources :users, only: :index
end
