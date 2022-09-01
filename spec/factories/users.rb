# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password_digest { BCrypt::Password.create('mypassword') }
  end
end
