Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :api do
    resources :users, except: %i[show destroy index]

    scope :tokens, controller: :tokens do
      post :create
      match :destroy, via: %i[get delete]
    end
  end

  namespace :v1, defaults: { format: :json } do
    concerns :api
  end
end
