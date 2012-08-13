require 'resque/server'
Burst::Application.routes.draw do
  resources :user_position_metrics

  resources :user_position_metric_points

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', as: :signout
  match '/auth/failure' => 'sessions#fail'

  root :to => 'articles#index'
  resources :articles
  resources :users  
  mount Resque::Server.new, :at => "/resque"
  post '/' => 'articles#index', as: :filter_articles
  
end
