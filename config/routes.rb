Rails.application.routes.draw do
  require 'sidekiq/web'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  root to: "home#index"

  post 'import', to: 'home#import'

  mount Sidekiq::Web, at: '/sidekiq'
end
