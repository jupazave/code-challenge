# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    tax_name { FFaker::Company.name }
    sequence(:tax_id) { |n| "ABB220831AB#{n}" }
  end
end
