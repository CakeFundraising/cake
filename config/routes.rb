Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: 
  {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations, confirmations: :confirmations}

  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end

  resources :direct_donations, only: :create

  resources :campaigns do
    member do
      scope :edit do
        get :tell_your_story
        get :sponsors
        get :share
      end
      get :badge
      get :pledge
      patch :launch
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
      patch :launch

      patch :accept
      patch :reject

      patch :click
    end
  end

  resources :fundraisers, except: :destroy do
    member do
      get :bank_account
      patch :set_bank_account
    end  
  end

  resources :sponsors, except: :destroy
  
  resources :pledge_requests do
    member do
      patch :accept
      patch :reject
    end
  end

  scope :payments, controller: :payments do
    post :invoice
  end
  
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
    resource :fundraiser_email_settings, only: [:edit, :update]
    resource :sponsor_email_settings, only: [:edit, :update]
  end

  resources :users, only: :index
end
