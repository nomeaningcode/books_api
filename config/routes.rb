Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do 
      resources :books, only: [:index,:create,:destroy]
      namespace :fh do
        get :ecategories
        get :icategories
        get :always_ok
        get :incomes
        get :expenses
      end

      post 'authenticate', to: 'authentication#create'
    end
  end
end
