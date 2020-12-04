# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  root to: 'static_pages#index'
  resources :events, only: [:index, :new, :create]
  namespace :admin do
    resources :events, only: [:index, :update, :destroy]
  end
  resources :status, only: [:create], controller: 'statuses'
end