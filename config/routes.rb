Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "assessments#index", as: :authenticated_root

    resources :assessments, only: [:index, :new, :create, :show, :edit, :update] do
      resources :responses, only: [:create, :update]
    end
  end

  unauthenticated do
    root to: "static#home"
  end

  get "home", to: "static#home"
end
