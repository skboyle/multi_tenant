Rails.application.routes.draw do
  devise_for :users,
            path: "",
            path_names: { sign_in: "login", sign_out: "logout", registration: "signup" },
            defaults: { format: :json },
            controllers: {
              sessions: "users/sessions",
              registrations: "users/registrations"
            }

  namespace :api do
    namespace :v1 do
      get "users/me", to: "users#me"
      patch "users/me", to: "users#update"
      post "signup", to: "auth#signup"

      resources :teams, only: [ :show, :update ]
      resources :projects do
        resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end
end
