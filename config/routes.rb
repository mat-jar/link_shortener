Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        get '/short_links', to: 'short_links#index'
        post '/short_links', to: 'short_links#create'
        put '/short_links', to: 'short_links#update'
        delete '/short_links', to: 'short_links#destroy'
        post '/short_links/show', to: 'short_links#show'

      end
  end

  get '/:slug', to: 'api/v1/short_links#redirect'

end
