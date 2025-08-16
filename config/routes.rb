Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  # Authentication routes
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Event and participant routes
  resources :events do
    resources :participants, only: [:create, :edit, :update, :destroy]
    resource :seating_chart, only: [:show, :update]
    resources :seating_tables, only: [:create, :update, :destroy]
  end
  get "my_events", to: "events#my_events"
  get "my_seat", to: "my_seating_assignments#show"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
