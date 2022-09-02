# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show qrcode update destroy]

  # GET /invoices
  def index
    @q = Invoice.ransack(params[:q])
    @invoices = @q.result
                  .page(params[:page])
                  .includes(:business_emitter, :business_receiver)

    render json: @invoices
  end

  # GET /invoices/1
  def show
    render json: @invoice
  end

  def qrcode
    render @invoice.qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_create_params)

    if @invoice.save
      render json: @invoice, status: :created, location: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_update_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_create_params
    params.require(:invoice)
          .permit(:business_emitter_id, :business_receiver_id, :status,
                  :invoice_uuid, :amount_cents, :amount_currency, :emitted_at,
                  :expires_at, :signed_at, :cfdi_digital_stamp)
  end

  def invoice_update_params
    params.require(:invoice)
          .permit(:business_emitter_id, :business_receiver_id, :status,
                  :amount_cents, :amount_currency, :emitted_at, :expires_at,
                  :signed_at, :cfdi_digital_stamp)
  end
end
