# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#login'
  resources :businesses
  resources :invoices
  resources :invoice_uploads, only: %i[create]
end
