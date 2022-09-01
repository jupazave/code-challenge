# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :business_emitter, class_name: 'Business'
  belongs_to :business_receiver, class_name: 'Business'

  monetize :amount_cents
end
