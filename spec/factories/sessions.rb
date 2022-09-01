# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    session_id { SecureRandom.uuid }
    user factory: :user
  end
end
