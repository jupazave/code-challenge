# frozen_string_literal: true

class InvoiceUpload < ApplicationRecord
  has_many_attached :invoices
  belongs_to :user

  validates :invoices, content_type: ['application/xml', 'text/xml'],
                       size: { less_than: 1.megabytes }
end
