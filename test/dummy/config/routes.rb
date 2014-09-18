Rails.application.routes.draw do
  root "home#index"

  namespace :admin do
    get "/google", to: redirect("https://www.google.com/"), as: :google

    resources :users do
      member do
        get :roles
      end
    end
  end
end
