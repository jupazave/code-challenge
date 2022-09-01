# frozen_string_literal: true

class InvoiceUploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(invoice_upload)
    @invoice_upload = invoice_upload

    build_invoices
    notify_invalid_invoices
    purge_invoices
  end

  private

  attr_reader :invoice_results, :invoice_upload

  def build_invoices
    @invoice_results = invoice_upload.invoices.map do |raw_invoice|
      invoice_result = RawInvoiceBuilder.call(raw_invoice.blob.download)
      raw_invoice.purge
      invoice_result
    end
  end

  def notify_invalid_invoices
    invalid_invoices_count =
      invoice_results.count do |invoice_result|
        !invoice_result.successful?
      end

    return if invalid_invoices_count.zero?

    InvoiceUploadInvalidNotifier.call(
      invoice_upload.user,
      invalid_invoices_count
    )
  end

  def purge_invoices
    invoice_upload.destroy!
  end
end
