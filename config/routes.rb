Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :api do
    resources :users, except: %i[show destroy index] do
      collection do
        get :me
      end
    end
    resources :lists do
      resources :notes
    end

    scope :tokens, controller: :tokens, as: :tokens do
      post "/", action: :create
      match "/", action: :destroy, via: %i[delete get]
    end
  end

  namespace :v1, defaults: { format: :json } do
    concerns :api
  end

  mount ActionCable.server => "/cable"
end
