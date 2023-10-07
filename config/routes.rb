Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/register', to: 'authentication#register'
      post '/login', to: 'authentication#login'
      get '/addresses/search', to: 'addresses#search'
      get 'addresses/search_by_cep/:cep', to: 'addresses#search_by_cep'
      resource :user, only: %i[show update destroy]

      get '/contacts/search', to: 'contacts#search'
      resources :contacts, only: %i[index show create update destroy]
    end
  end
end
