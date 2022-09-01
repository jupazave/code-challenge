# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    invoice_uuid { SecureRandom.uuid }
    business_emitter { create(:business) }
    business_receiver { create(:business) }

    status { :active }
    amount_cents { 100_00 }
    amount_currency { 'MXN' }

    emitted_at { FFaker::Time.between(32.days.from_now, 1.day.ago) }
    expires_at { FFaker::Time.between(emitted_at, 30.days.from_now) }
    signed_at { emitted_at }
  end
end
