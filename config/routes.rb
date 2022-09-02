# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#login'
  resources :businesses, except: %i[destroy]
  resources :invoices do
    member do
      get 'qrcode', to: 'invoices#qrcode'
    end
  end
  resources :invoice_uploads, only: %i[create]
end
