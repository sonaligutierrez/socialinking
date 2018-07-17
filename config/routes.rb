Rails.application.routes.draw do
  require "sidekiq/web"

  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "admin/dashboard#index"

  get "/posts/scraping/:id", to: "posts#scraping", as: "post_scraping"
  get "/unauthorized", to: "unauthorized#index", as: "unauthorized"

end
