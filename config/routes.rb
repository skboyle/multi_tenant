Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  namespace :api do
    namespace :v1 do
      # Current user routes
      get "users/me", to: "users#me"
      patch "users/me", to: "users#update"
      # Team routes
      resources :teams, only: [ :show, :update ]

      # Project routes
      resources :projects

      # Task routes
      resources :tasks
    end
  end
end
