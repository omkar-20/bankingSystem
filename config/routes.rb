Rails.application.routes.draw do
  devise_for :users, 
             defaults: { format: :json }, 
             path: '', 
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
              sessions: 'users/sessions',
              registrations: 'users/registrations'
             }

  namespace :admin do
    resources :transactions, only: [:index]
    resources :customers, only: [:index, :create, :destroy] do
      member do
        patch 'update_status', to: 'customers#update_status'
      end
    end
  end

  namespace :customers do 
    resource :profile, only: [:show, :update]
    resources :transactions, only: [:create, :index]

    get 'dashboard', to: 'dashboard#show'
  end
end
