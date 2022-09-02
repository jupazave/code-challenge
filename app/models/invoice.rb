# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :business_emitter, class_name: 'Business'
  belongs_to :business_receiver, class_name: 'Business'

  validates :invoice_uuid, presence: true, uniqueness: { case_sensitive: false }

  monetize :amount_cents

  def qrcode
    RQRCode::QRCode.new(cfdi_digital_stamp)
  end
end
