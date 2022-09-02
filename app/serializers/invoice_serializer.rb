# frozen_string_literal: true

class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :status, :invoice_uuid, :amount_cents, :amount_currency,
             :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp,
             :business_emitter, :business_receiver

  belongs_to :business_emitter, class_name: 'Business'
  belongs_to :business_receiver, class_name: 'Business'

  def amount_cents
    object.amount.cents
  end
end
