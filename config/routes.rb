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

  resources :users, only: :index do
    collection do
      namespace :settings do
        get :account      
        get :update_account      

        get :email_notifications      
        get :update_email_notifications      
      end
    end
  end
end
