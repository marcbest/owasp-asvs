Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "assessments#index", as: :authenticated_root

    resources :assessments, only: [:index, :new, :create, :show, :edit, :update] do
      member do
        get :export
      end
      resources :responses, only: [:create, :update]
      resources :sharing_urls, only: [:index, :create, :destroy]
    end
  end

  unauthenticated do
    root to: "static#home"
  end
  get "shared/:uuid", to: "sharing_urls#show", as: :shared_assessment
  get "home", to: "static#home"
end
