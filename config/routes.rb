Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        resources :short_links
      end
  end

  get '/:slug', to: 'api/v1/short_links#redirect'

end
