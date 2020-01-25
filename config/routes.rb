# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'static_pages#index'
  resources :events, only: [:index, :new, :create]
end