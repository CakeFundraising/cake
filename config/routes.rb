Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: 
  {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations, sessions: :sessions}

  root to: "home#index"

  authenticated :user do
    mount Resque::Server, at: "/resque"
  end

  namespace :home, path:'/' do
    get :get_started
  end

  #Static pages
  get "/about/*id" => 'about#show', as: :about_page, format: false
  get "/help/*id" => 'help#show', as: :help_page, format: false

  resources :direct_donations, only: :create

  scope :search, controller: :searches do
    get :search_campaigns, path:'campaigns'
    get :search_sponsors, path:'sponsors'
    get :search_coupons, path:'coupons'
  end

  resources :campaigns do
    member do
      scope :edit do
        get :tell_your_story
        get :sponsors
        get :launch_wizard, path: :launch
        get :share
      end
      get :badge
      patch :launch
      patch :save_for_launch
      patch :toggle_visibility

      scope :pictures, controller: :cropping do
        post :crop
      end
    end
  end

  resources :pledges do
    collection do
      get :select_campaign
    end

    member do
      scope :edit do
        get :tell_your_story
        get :add_coupon
        get :add_sweepstakes
        get :share
      end

      scope :pictures, controller: :cropping do
        post :crop
      end

      get :increase
      patch :set_increase
      patch :increase_request

      get :badge
      patch :launch

      patch :accept
      patch :reject
      get :add_reject_message

      get :click
    end
  end

  resources :quick_pledges, except: :show

  resources :fundraisers, except: [:index, :destroy] do
    member do
      get :bank_account
      patch :set_bank_account
      scope :pictures, controller: :cropping do
        post :crop
      end
    end  
  end

  resources :sponsors, except: [:index, :destroy] do
    member do
      get :credit_card
      patch :set_credit_card
      scope :pictures, controller: :cropping do
        post :crop
      end
    end 
  end

  resources :fr_sponsors, except: [:index, :show]
  
  resources :pledge_requests do
    member do
      patch :accept
      patch :reject
    end
  end

  scope :payments, controller: :payments do
    post :invoice_payment
  end
  
  #FR Dashboard
  namespace :fundraiser, controller: :dashboard do
    get :home
    get :billing
    get :pledges
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

  resources :coupons do
    member do
      get :download
      scope :pictures, controller: :cropping do
        post :crop
      end
    end
  end

  namespace :locations do
    get :subregion_options
  end

  resources :impressions do
    patch :rendered
  end

  scope :browser, controller: :browsers do
    patch :fingerprint
  end

  #Settings
  scope :settings do
    get :public_profile, controller: :settings

    get :account, to: redirect('users/edit')
    resource :fundraiser_email_settings, only: [:edit, :update]
    resource :sponsor_email_settings, only: [:edit, :update]
  end

  resources :users, only: :index do
    collection do
      patch :roles
    end
  end

  # Adds routes for evercookie under namespace (path)
  scope "#{Evercookie.get_namespace}" do
    # route for js file to set cookie
    get 'set' => "evercookie/evercookie#set", as: :evercookie_set
    # route for js file to get cookie
    get 'get' => "evercookie/evercookie#get", as: :evercookie_get
    # route for save action to save cookie value to session
    get 'save' => "evercookie/evercookie#save", as: :evercookie_save

    # route to png image to be tracked by js script
    get 'ec_png' => "evercookie/evercookie#ec_png", as: :evercookie_png
    # route to etag action to be tracked by js script
    get 'ec_etag' => "evercookie/evercookie#ec_etag", as: :evercookie_etag
    # route to cache action to be tracked by js script
    get 'ec_cache' => "evercookie/evercookie#ec_cache", as: :evercookie_cache
    # route to basic auth to be tracked by js script
    get 'ec_auth' => "evercookie/evercookie#ec_auth", as: :evercookie_auth
  end
end
