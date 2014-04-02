Cake::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations}
  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end
end
