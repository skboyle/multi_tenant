Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Devise routes for JSON API
      devise_for :users,
                 path: "",
                 path_names: { sign_in: "login", sign_out: "logout", registration: "signup" },
                 controllers: {
                   sessions: "api/v1/sessions",
                   registrations: "api/v1/registrations"
                 },
                 defaults: { format: :json }

      # Current user routes
      get "users/me", to: "users#me"
      patch "users/me", to: "users#update"

      # Team routes
      resources :teams, only: [ :show, :update ]

      # Project and task routes
      resources :projects do
        resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end
end
