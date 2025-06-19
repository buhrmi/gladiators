Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :guilds
  resource :guild
  resources :fights
  resources :characters
  resource :session
  resources :auctions

  get "/auth/:provider/callback", to: "sessions#create"
  get "install", to: redirect("https://discord.com/oauth2/authorize?client_id=1153706516583563324")
  inertia "bot" => "static/bot", nav: "bot"

  # Defines the root path route ("/")
  root to: "characters#index"
end
