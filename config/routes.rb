Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        get '/short_links', to: 'short_links#index'
        post '/short_links', to: 'short_links#create'
        put '/short_links', to: 'short_links#update'
        delete '/short_links', to: 'short_links#destroy'
        post '/short_links/show', to: 'short_links#show'
        post '/short_links/fetch_og_tags', to: 'short_links#fetch_og_tags'

        post '/login', to: 'authentication#login'

        get '/users', to: 'users#index'
        post '/users', to: 'users#create'
        put '/users', to: 'users#update'
        delete '/users', to: 'users#destroy'
        get '/users/show', to: 'users#show'

      end
  end

  get '/:slug', to: 'api/v1/short_links#redirect'

end
