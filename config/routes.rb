Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations}
  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end

  resources :users, only: :index do
    collection do
      namespace :settings do
        resources :fundraiser_profiles, except: [:index, :destroy, :new, :create]

        get :account      
        get :update_account      

        get :email_notifications      
        get :update_email_notifications      
      end
    end
  end
end
