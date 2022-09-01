# frozen_string_literal: true

class RawInvoiceBuilder
  method_object :raw_xml

  def call
    return error_result unless valid?

    find_or_update_invoice
    successful_result
  end

  private

  attr_reader :invoice

  def error_result
    OpenStruct.new(
      successful?: false,
      errors:
    )
  end

  def successful_result
    OpenStruct.new(
      successful?: true,
      invoice:
    )
  end

  def valid?
    %w[
      invoice_uuid amount_cents amount_currency emitter_tax_name
      emitter_tax_id receiver_tax_name receiver_tax_id emitted_at
      expires_at signed_at cfdi_digital_stamp
    ].each do |attribute|
      errors << "missing_#{attribute}".to_sym if send(attribute).blank?
    end

    errors.empty?
  end

  def find_or_update_invoice
    @invoice =
      Invoice.where(invoice_uuid:).first_or_initialize.tap do |invoice|
        invoice.assign_attributes(
          amount_cents:,
          amount_currency:,
          emitted_at:,
          expires_at:,
          signed_at:,
          cfdi_digital_stamp:,
          raw_xml:,
          business_emitter:,
          business_receiver:
        )

        invoice.save!
      end
  end

  def business_emitter
    @business_emitter ||= Business.create_with(tax_name: emitter_tax_name)
                                  .find_or_create_by!(tax_id: emitter_tax_id)
  end

  def emitter_tax_name
    @emitter_tax_name ||= xml_at_path('//hash/emitter/name')
  end

  def emitter_tax_id
    @emitter_tax_id ||= xml_at_path('//hash/emitter/rfc')&.upcase
  end

  def business_receiver
    @business_receiver ||= Business.create_with(tax_name: receiver_tax_name)
                                   .find_or_create_by!(tax_id: receiver_tax_id)
  end

  def receiver_tax_name
    @receiver_tax_name ||= xml_at_path('//hash/receiver/name')
  end

  def receiver_tax_id
    @receiver_tax_id ||= xml_at_path('//hash/receiver/rfc')&.upcase
  end

  def invoice_uuid
    @invoice_uuid ||= xml_at_path('//hash/invoice_uuid')&.downcase
  end

  def amount_cents
    @amount_cents ||= xml_at_path('//hash/amount/cents')&.to_i
  end

  def amount_currency
    @amount_currency ||= xml_at_path('//hash/amount/currency')&.upcase
  end

  def emitted_at
    @emitted_at ||= xml_at_path('//hash/emitted_at')&.to_date
  end

  def expires_at
    @expires_at ||= xml_at_path('//hash/expires_at')&.to_date
  end

  def signed_at
    @signed_at ||= xml_at_path('//hash/signed_at')&.to_date
  end

  def cfdi_digital_stamp
    @cfdi_digital_stamp ||= xml_at_path('//hash/cfdi_digital_stamp')
  end

  def xml_at_path(path)
    xml.at_xpath(path)&.children&.first&.content
  end

  def xml
    return @xml if @xml.present?

    @xml = Nokogiri::XML(raw_xml, &:noblanks)
    @xml.remove_namespaces!
    @xml
  end

  def errors
    @errors ||= []
  end
end
