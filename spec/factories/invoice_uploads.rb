# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_upload do
    user factory: :user

    trait :with_valid_invoice do
      after(:build) do |invoice_upload|
        invoice_upload.invoices.attach(
          filename: 'test-invoice.xml',
          content_type: 'application/xml',
          io: File.open(Rails.root.join('spec/fixtures/test-invoice.xml'))
        )
      end
    end

    trait :with_invalid_invoice do
      after(:build) do |invoice_upload|
        invoice_upload.invoices.attach(
          filename: 'test-invoice-invalid.xml',
          content_type: 'application/xml',
          io: File.open(
            Rails.root.join('spec/fixtures/test-invoice-invalid.xml')
          )
        )
      end
    end

    trait :with_valid_and_invalid_invoice do
      with_valid_invoice
      with_invalid_invoice
    end
  end
end
