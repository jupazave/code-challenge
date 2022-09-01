# frozen_string_literal: true

class InvoiceUpload < ApplicationRecord
  has_many_attached :invoices
  belongs_to :user
end
