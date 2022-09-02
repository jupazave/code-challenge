# frozen_string_literal: true

class BusinessSerializer < ActiveModel::Serializer
  attributes :id, :tax_name, :tax_id

  has_many :emitted_invoices, class_name: 'Invoice'
end
