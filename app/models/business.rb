# frozen_string_literal: true

class Business < ApplicationRecord
  has_many :emitter_invoices, class_name: 'Invoice',
                              foreign_key: 'business_emitter_id',
                              dependent: :destroy,
                              inverse_of: :business_emitter
  has_many :receiver_invoices, class_name: 'Invoice',
                               foreign_key: 'business_receiver_id',
                               dependent: :destroy,
                               inverse_of: :business_receiver
end