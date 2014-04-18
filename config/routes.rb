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

  resources :pledges do
    member do
      scope :edit do
        get :tell_your_story
        get :add_coupon
        get :add_sweepstakes
        get :share
      end
      get :badge
    end
  end

  resources :fundraisers, except: :destroy
  resources :sponsors, except: :destroy
  
  #FR Dashboard
  namespace :fundraiser, controller: :dashboard do
    get :home
    get :billing
    get :pending_pledges
    get :campaigns
    get :history
  end

  #Sponsor Dashboard
  namespace :sponsor, controller: :dashboard do
    get :home
    get :billing
    get :pledge_requests
    get :active_pledges
    get :history
  end

  namespace :locations do
    get :subregion_options
  end

  #Settings
  scope :settings do
    get :public_profile, controller: :settings

    get :account, to: redirect('users/edit')
    resource :email_settings, only: [:edit, :update]
  end

  resources :users, only: :index
end
