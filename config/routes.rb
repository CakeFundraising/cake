Cake::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks, registrations: :registrations}
  root to: "home#index"

  namespace :home, path:'/' do
    get :get_started
  end
end
