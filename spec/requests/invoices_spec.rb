# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/invoices', type: :request do
  let(:session) { create(:session) }
  let!(:headers) do
    {
      Authorization: "Bearer #{session.session_id}"
    }
  end

  let!(:business_emitter) { create(:business) }
  let!(:business_receiver) { create(:business) }
  let!(:invoice) do
    create(:invoice, business_emitter:,
                     business_receiver:)
  end

  let(:valid_attributes) do
    {
      business_emitter_id: business_emitter.id,
      business_receiver_id: business_receiver.id,
      status: 'active',
      invoice_uuid: SecureRandom.uuid,
      amount_cents: 100_00,
      amount_currency: 'MXN',
      emitted_at: 1.day.ago,
      expires_at: 30.days.from_now,
      signed_at: 1.day.ago,
      cfdi_digital_stamp: FFaker::DizzleIpsum.characters
    }
  end

  let(:invalid_attributes) do
    {
      business_emitter_id: business_emitter.id,
      business_receiver_id: 999,
      status: 'active',
      invoice_uuid: invoice.invoice_uuid,
      amount_cents: 100_00,
      amount_currency: 'MXN',
      emitted_at: 1.day.ago,
      expires_at: 30.days.from_now,
      signed_at: 1.day.ago,
      cfdi_digital_stamp: FFaker::DizzleIpsum.characters
    }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /index' do
    subject { get invoices_url, headers:, as: :json }

    it 'renders a successful response' do
      subject
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    subject { get invoice_url(invoice), headers:, as: :json }

    it 'renders a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'renders the invoice' do
      subject
      expect(json).to \
        match(
          a_hash_including(
            {
              'id' => invoice.id,
              'business_emitter' =>
              a_hash_including(
                {
                  'id' => business_emitter.id,
                  'tax_name' => business_emitter.tax_name,
                  'tax_id' => business_emitter.tax_id
                }
              ),
              'business_receiver' =>
              a_hash_including(
                {
                  'id' => business_receiver.id,
                  'tax_name' => business_receiver.tax_name,
                  'tax_id' => business_receiver.tax_id
                }
              ),
              'status' => invoice.status,
              'invoice_uuid' => invoice.invoice_uuid,
              'amount_cents' => invoice.amount.cents,
              'amount_currency' => invoice.amount.currency.iso_code,
              'emitted_at' => invoice.emitted_at.iso8601,
              'expires_at' => invoice.expires_at.iso8601,
              'signed_at' => invoice.signed_at.iso8601
            }
          )
        )
    end
  end

  describe 'GET /qrcode' do
    subject { get qrcode_invoice_url(invoice), headers:, as: :json }

    it 'renders a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'renders the qrcode' do
      subject
      expect(response.body).to eq(invoice.qrcode.as_png(size: 300).to_s)
      expect(response.header['Content-Type']).to eq('image/png')
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      subject do
        post invoices_url, params: { invoice: valid_attributes },
                           headers:, as: :json
      end

      it 'creates a new Invoice' do
        expect { subject }.to change(Invoice, :count).by(1)
      end

      it 'renders a JSON response with the new invoice' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      subject do
        post invoices_url, params: { invoice: invalid_attributes },
                           headers:, as: :json
      end

      it 'does not create a new Invoice' do
        expect { subject }.not_to change(Invoice, :count)
      end

      it 'renders a JSON response with errors for the new invoice' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      subject do
        patch invoice_url(invoice),
              params: { invoice: new_attributes }, headers:, as: :json
      end

      let(:new_attributes) do
        {
          amount_cents: 100_000_00,
          invoice_uuid: SecureRandom.uuid
        }
      end

      it 'updates the requested invoice' do
        subject
        expect { invoice.reload }.to change(invoice, :amount_cents)
        expect { invoice.reload }.not_to change(invoice, :invoice_uuid)
        expect(invoice.reload.amount_cents).to eq(new_attributes[:amount_cents])
      end

      it 'renders a JSON response with the invoice' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      subject do
        patch invoice_url(invoice),
              params: { invoice: invalid_attributes }, headers:, as: :json
      end

      let!(:invalid_attribtues) do
        { business_receiver_id: 999_999 }
      end

      it 'renders a JSON response with errors for the invoice' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete invoice_url(invoice), headers:, as: :json }

    it 'destroys the requested invoice' do
      expect { subject }.to change(Invoice, :count).by(-1)
    end
  end
end
