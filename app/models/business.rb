# frozen_string_literal: true

class Business < ApplicationRecord
  has_many :emitted_invoices, class_name: 'Invoice',
                              foreign_key: 'business_emitter_id',
                              dependent: :destroy,
                              inverse_of: :business_emitter
  has_many :received_invoices, class_name: 'Invoice',
                               foreign_key: 'business_receiver_id',
                               dependent: :destroy,
                               inverse_of: :business_receiver

  validates :tax_name, presence: true
  validates :tax_id, presence: true, uniqueness: true
end
