# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    tax_name { FFaker::NameMX.full_name }
    tax_id { FFaker::IdentificationMX.rfc }
  end
end
