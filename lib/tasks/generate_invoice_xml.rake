# frozen_string_literal: true

require 'builder'

namespace :xml do
  desc 'Generate invoice with fake data'
  task generate_invoice: [:environment] do

    def invoice_xml(invoice_uuid)
      xml = Builder::XmlMarkup.new( indent: 2 )
      xml.instruct! :xml, encoding: "UTF-8", version: '1.0'
      xml.hash do |hash|
        hash.invoice_uuid invoice_uuid
        hash.status 'active'
        hash.emitter do |emitter|
          emitter.name FFaker::NameMX.full_name
          emitter.rfc FFaker::IdentificationMX.rfc_persona_moral
        end
        hash.receiver do |receiver|
          receiver.name FFaker::NameMX.full_name
          receiver.rfc FFaker::IdentificationMX.rfc_persona_moral
        end
        hash.amount do |amount|
          amount.comment! 'eg. 1234 cents = 12.34'
          amount.cents rand(1_000_000), type: 'integer'
          amount.comment! 'ISO 4217'
          amount.currency FFaker::Currency.code
        end
        hash.emitted_at FFaker::Time.date, type: 'date'
        hash.expires_at FFaker::Time.date, type: 'date'
        hash.signed_at FFaker::Time.date, type: 'date'
        hash.cfdi_digital_stamp FFaker::DizzleIpsum.characters, type: 'text'
      end
    end

    invoice_uuid = SecureRandom.uuid
    File.open("public/20220811012132-invoices/#{invoice_uuid}.xml", 'w') do |f|
      f.write(invoice_xml(invoice_uuid))
    end
  end
end
