# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InvoiceUploads', type: :request do
  describe 'GET /create' do
    subject do
      post(invoice_uploads_url, params: {
                                  invoice_upload: { invoices: [file] }
                                },
                                headers:)
    end

    let!(:session) { create(:session) }
    let(:headers) do
      {
        Authorization: "Bearer #{session.session_id}"
      }
    end

    let(:file) do
      fixture_file_upload(
        Rails.root.join('spec/fixtures/test-invoice-invalid.xml'), 'text/xml'
      )
    end

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns a JSON response with the new invoice_upload' do
      subject
      expect(response.content_type).to \
        match(a_string_including('application/json'))
    end

    it 'creates a new InvoiceUpload' do
      expect { subject }.to change(InvoiceUpload, :count).by(1)
    end

    it 'enqueues a job' do
      expect { subject }.to have_enqueued_job(InvoiceUploadProcessorJob)
    end

    context 'when the file is not an XML file' do
      let(:file) do
        fixture_file_upload(
          Rails.root.join('spec/fixtures/test-invoice.pdf'), 'application/pdf'
        )
      end

      it 'returns http unprocessable_entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a JSON response with the errors' do
        subject
        expect(response.content_type).to \
          match(a_string_including('application/json'))
      end

      it 'does not create a new InvoiceUpload' do
        expect { subject }.not_to change(InvoiceUpload, :count)
      end

      it 'does not enqueue a job' do
        expect { subject }.not_to have_enqueued_job(InvoiceUploadProcessorJob)
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }

      it 'returns http unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
