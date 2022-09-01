# frozen_string_literal: true

class InvoiceUploadsController < ApplicationController
  def create
    @invoice_upload =
      InvoiceUpload.new(invoice_upload_params.merge(user: current_user))

    if @invoice_upload.save
      InvoiceUploadProcessorJob.perform_later(@invoice_upload)
      render json: @invoice_upload, status: :created
    else
      render json: @invoice_upload.errors, status: :unprocessable_entity
    end
  end

  private

  def invoice_upload_params
    params.require(:invoice_upload).permit(invoices: [])
  end
end
